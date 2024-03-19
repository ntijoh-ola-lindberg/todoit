class Seeder

    def self.seed!
       drop_tables 
       create_tables
       populate_todos
    end

private 

    def self.db 
        @db ||= SQLite3::Database.new("db/app.sqlite")
    end

    def self.drop_tables
        db.execute("DROP TABLE IF EXISTS todos")
    end

    def self.create_tables
        db.execute("CREATE TABLE todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            todo_title VARCHAR(255) NOT NULL,
            todo_description VARCHAR(255) NOT NULL,
            is_completed INTEGER NOT NULL
            )
        ");
    end

    def self.populate_todos
        todos = [
            {todo_title: "Första todon", todo_description: "Beskrivning av första todon", is_completed: 1},
            {todo_title: "Andra todon", todo_description: "Beskrivning av andra todon", is_completed: 0}
        ]

        todos.each do |todo|
            db.execute("INSERT INTO todos (todo_title, todo_description, is_completed) VALUES (?,?,?)", 
                todo[:todo_title], todo[:todo_description], todo[:is_completed]);
        end
    end

end