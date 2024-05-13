class App < Sinatra::Base 

    before do 
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true
    end

    get '/' do
        sql_todos = 'SELECT todos.*, categories.category_title
            FROM todos 
	            INNER JOIN categories 
		            ON category_id = categories.id'

        @todos = @db.execute(sql_todos)

        sql_categories = 'SELECT * FROM categories'
        @categories = @db.execute(sql_categories) 

        erb :'todos/index'
    end

    post '/todos/new-todo' do 
        title = params['todo_title']
        description = params['todo_description']
        is_completed = 0
        category = params['category']
        
        status = @db.execute("INSERT INTO todos (todo_title, todo_description, is_completed, category_id) VALUES (?,?,?,?)", title, description, is_completed, category)

        redirect '/'
    end

    post '/todos/:id/toggle-completion' do | id | 
        status = @db.execute("UPDATE todos SET is_completed = ((is_completed | 1) - (is_completed & 1)) WHERE id =?", id)

        redirect '/'
    end

    post '/todos/:id/delete' do | id | 
        status = @db.execute("DELETE FROM todos WHERE id =?", id)

        redirect '/'
    end

    get '/categories' do
        sql_categories = 'SELECT * FROM categories'
        @categories = @db.execute(sql_categories) 

        erb :'categories/index'
    end

    get '/categories/:id' do | id |
        sql_categories = 'SELECT * FROM categories WHERE id =?'
        @category = @db.execute(sql_categories, id)
        erb :'categories/edit'
    end

    post '/categories/:id/update' do | id |
        ct = params['category_title']
        puts "Updating id: " + id + " category: " + ct
        
        sql = "UPDATE categories SET category_title =? WHERE id =?"

        status = @db.execute(sql, ct, id)

        puts status

        redirect '/'

    end
    
end