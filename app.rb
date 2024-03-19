require "sinatra"
require "sinatra/base"
require 'sqlite3'

class App < Sinatra::Base 

    before do 
        @db = SQLite3::Database.new("db/app.sqlite")
        @db.results_as_hash = true
    end

    get '/' do
        @todos = @db.execute("SELECT * FROM todos") 
        erb :index
    end

    post '/new-todo' do
        title = params['todo_title'].to_s
        description = params['todo_description'].to_s
        is_completed = 0
        
        status = @db.execute("INSERT INTO todos (todo_title, todo_description, is_completed) VALUES (?,?,?)", title, description, is_completed)

        redirect '/'
    end

    post '/todos/:id/toggle-completion' do | id | 
        status = @db.execute("UPDATE todos SET is_completed = ((is_completed | 1) - (is_completed & 1)) WHERE id =?", id)
        redirect '/'
    end

    
    
end