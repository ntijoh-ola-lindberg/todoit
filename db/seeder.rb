class Seeder

    def self.seed!
       drop_tables 
       create_tables
       populate_todos
       self.populate_categories
    end

private 

    def self.db 
        @db ||= SQLite3::Database.new("db/app.sqlite")
    end

    def self.drop_tables
        db.execute("DROP TABLE IF EXISTS todos")
        db.execute("DROP TABLE IF EXISTS categories")
    end

    def self.create_tables
        db.execute('CREATE TABLE "todos" (
                    "id" INTEGER NOT NULL UNIQUE,
                    "todo_title" TEXT NOT NULL,
                    "todo_description" TEXT NOT NULL,
                    "is_completed" INTEGER NOT NULL DEFAULT 0,
                    "category_id" INTEGER,
                    PRIMARY KEY("id" AUTOINCREMENT),
                    FOREIGN KEY("category_id") REFERENCES "categories"("id")
                    );'
        )

        db.execute('CREATE TABLE "categories" (
	                    "id" INTEGER NOT NULL UNIQUE,
                        "category_title" TEXT,
	                    PRIMARY KEY("id" AUTOINCREMENT)
                    );'
        )
    end

    def self.populate_categories
        categories = [
            {category_title: "Privat"},
            {category_title: "Jobb"}
        ]

        categories.each do | c |
            db.execute('INSERT INTO categories (category_title) VALUES (?)',
            c[:category_title])
    end
end

    def self.populate_todos
        todos = [
            {todo_title: "Första todon", todo_description: "Beskrivning av första todon", is_completed: 1, category_id: 1 },
            {todo_title: "Andra todon", todo_description: "Beskrivning av andra todon", is_completed: 0, category_id: 2 }
        ]

        todos.each do |todo|
            db.execute("INSERT INTO todos (todo_title, todo_description, is_completed, category_id) VALUES (?,?,?,?)", 
                todo[:todo_title], todo[:todo_description], todo[:is_completed], todo[:category_id])
        end
    end

end