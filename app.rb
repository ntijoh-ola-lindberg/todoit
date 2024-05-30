class App < Sinatra::Base 

    def db
        return @db if @db

        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true

        return @db
    end

    def get_all_categories
        sql_categories = 'SELECT * FROM categories'
        categories = db.execute(sql_categories)

        return categories
    end

    get '/' do
        sql_todos = 'SELECT todos.*, categories.category_title
            FROM todos 
	            INNER JOIN categories 
		            ON category_id = categories.id'

        @todos = db.execute(sql_todos)

        @categories = get_all_categories

        erb :'todos/index'
    end

    #post '/todos/
    #CREATE
    post '/todos/new-todo' do 
        title = params['todo_title']
        description = params['todo_description']
        is_completed = 0
        category = params['category']
        
        status = db.execute("INSERT INTO todos (todo_title, todo_description, is_completed, category_id) VALUES (?,?,?,?)", title, description, is_completed, category)

        redirect '/'
    end

    post '/todos/:id/toggle-completion' do | id | 
        status = db.execute("UPDATE todos SET is_completed = ((is_completed | 1) - (is_completed & 1)) WHERE id =?", id)

        redirect '/'
    end

    #Show : Restful route
    #get '/todos/:id'
    #end

    #Edit : Restful route. Fetches and populates the form that is saved with Update (below).
    get '/todos/:id/edit' do | id |
        sql_todos = 'SELECT todos.*, categories.category_title
            FROM todos 
	            INNER JOIN categories 
		            ON category_id = categories.id
            WHERE todos.id = ?'

        @todo = db.execute(sql_todos, id)[0]

        @categories = get_all_categories

        erb :'todos/update'
    end

    #Update : Restful route. Saves the form for the given ID.
    post '/todos/:id' do | id |
    
        todo_id = params['todo_id']
        todo_title = params['todo_title']
        todo_description = params['todo_description']
        if params.has_key?('is_completed')
            is_completed = 1
        else 
            is_completed = 0
        end
        category_title = params['category']

        sql_category_id = 'SELECT * FROM categories WHERE category_title LIKE ?'
        category_id = db.execute(sql_category_id, category_title).first['id']

        sql_save_todo = 'UPDATE todos SET todo_title =?, todo_description =?, is_completed=?, category_id=? WHERE id=?'
        status = db.execute(sql_save_todo, todo_title, todo_description, is_completed, category_id, todo_id)

        redirect '/'
    end

    post '/todos/:id/delete' do | id | 
        status = db.execute("DELETE FROM todos WHERE id =?", id)

        redirect '/'
    end

    get '/categories' do
        sql_categories = 'SELECT * FROM categories'
        @categories = db.execute(sql_categories) 

        erb :'categories/index'
    end

    get '/categories/:id' do | id |
        sql_categories = 'SELECT * FROM categories WHERE id =?'
        @category = db.execute(sql_categories, id)

        sql_todos = 'SELECT todos.*, categories.category_title
            FROM todos 
	            INNER JOIN categories 
		            ON category_id = categories.id
            WHERE category_id=?'

        @todos = db.execute(sql_todos, id)

        sql_categories = 'SELECT * FROM categories'
        @categories = db.execute(sql_categories)

        erb :'categories/edit'
    end

    post '/categories/:id/update' do | id |
        ct = params['category_title']
        sql = "UPDATE categories SET category_title =? WHERE id =?"
        status = db.execute(sql, ct, id)
        redirect '/'
    end

    post '/categories/:id/delete' do | id |
        status = db.execute("DELETE FROM categories WHERE id =?", id)
        redirect '/categories'
    end

    post '/categories/new' do
        ct = params['category_title']
        sql = "INSERT INTO categories (category_title) VALUES (?)"
        status = db.execute(sql, ct)
        redirect '/categories'
    
    end
    
end