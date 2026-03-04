require 'awesome_print'
require_relative 'models/base_model'
require_relative 'models/todo'
require_relative 'models/category'

class App < Sinatra::Base
  setup_development_features(self)

  def db
    return @db if @db

    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true

    @db
  end

  get '/' do
    redirect('/todos')
  end

  get '/todos' do
    @todos = Todo.all
    @categories = Category.all
    erb :'todos/index'
  end

  post '/todos' do
    is_completed = 0 #New ToDos cannot be completed
    Todo.create(params['todo_title'],
                params['todo_description'],
                is_completed,
                params['category'])

    redirect '/'
  end

  # ToDo
  post '/todos/:id/toggle-completion' do |id|
    status = db.execute('UPDATE todos SET is_completed = ((is_completed | 1) - (is_completed & 1)) WHERE id =?', id)

    redirect '/'
  end

  # ToDo
  # Show : Restful route
  # get '/todos/:id'
  # end

  get '/todos/:id/edit' do |id|
    @todo = Todo.find(id)
    @categories = Category.all

    erb :'todos/edit'
  end

  # Update : Restful route. Saves the form for the given ID.
  post '/todos/:id/update' do |id|

    # Checkbox is_completed is only passed from html form if it is checked
    if params.has_key?('is_completed')
      is_completed = 1
    else
      is_completed = 0
    end

    Todo.update(id, params['todo_title'], params['todo_description'], is_completed, params['category_id'])
    redirect '/'
  end

  post '/todos/:id/delete' do |id|
    Todo.destroy(id)
    redirect '/'
  end

  get '/categories' do
    @categories = Category.all
    erb :'categories/index'
  end

  get '/categories/:id/edit' do |id|
    @category = Category.find(id)
    @todos = Todo.all_by_category_id(id)
    @categories = Category.all

    erb :'categories/edit'
  end

  post '/categories/:id/update' do |id|
    ct = params['category_title']
    sql = 'UPDATE categories SET category_title =? WHERE id =?'
    status = db.execute(sql, [ct, id])
    redirect '/'
  end

  post '/categories/:id/delete' do |id|
    status = db.execute('DELETE FROM categories WHERE id =?', id)
    redirect '/categories'
  end

  post '/categories/new' do
    ct = params['category_title']
    sql = 'INSERT INTO categories (category_title) VALUES (?)'
    status = db.execute(sql, ct)
    redirect '/categories'
  end
end
