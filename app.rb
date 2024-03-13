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
    
end