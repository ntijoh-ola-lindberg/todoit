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
        @tt = params['todo_title'].to_s
        @td = params['todo_description'].to_s

        status = @db.execute("INSERT INTO todos (todo_title, todo_description) VALUES (?,?)",@tt, @td)
        p status

        redirect '/'
    end
    
end