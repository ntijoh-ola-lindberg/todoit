require 'sqlite3'
require_relative '../config'

class Seeder
  def self.seed!
    @db = nil

    puts "Using db file: #{DB_PATH}"
    puts '🧹 Dropping old tables...'
    drop_tables
    puts '🧱 Creating tables...'
    create_tables
    puts '🍎 Populating tables...'
    populate_todos
    populate_categories
    puts '✅ Done seeding the database!'
  end

  private

  def self.db
    @db ||= begin
      db = SQLite3::Database.new(DB_PATH)
      db.results_as_hash = true
      db
    end
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS todos')
    db.execute('DROP TABLE IF EXISTS categories')
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
                    );')

    db.execute('CREATE TABLE "categories" (
	                    "id" INTEGER NOT NULL UNIQUE,
                        "category_title" TEXT,
	                    PRIMARY KEY("id" AUTOINCREMENT)
                    );')
  end

  def self.populate_categories
    categories = [
      { category_title: 'Privat' },
      { category_title: 'Köp' },
      { category_title: 'Jobb' }
    ]

    categories.each do |c|
      db.execute('INSERT INTO categories (category_title) VALUES (?)',
                 c[:category_title])
    end
  end

  def self.populate_todos
    todos = [
      { todo_title: 'Första todon', todo_description: 'Beskrivning av första todon', is_completed: 1,
        category_id: 3 },
      { todo_title: 'Laga pannkakor', todo_description: '2 1/2 dl vetemjöl - 1/2 tsk salt - 6 dl mjölk - 3  ägg',
        is_completed: 0, category_id: 1 },
      { todo_title: 'Mjölk', todo_description: 'Två liter', is_completed: 0, category_id: 2 },
      { todo_title: 'Ägg', todo_description: 'Ett tjog', is_completed: 0, category_id: 2 },
      { todo_title: 'Mjöl', todo_description: 'Fyra kg', is_completed: 0, category_id: 2 },
      { todo_title: 'Smör', todo_description: 'Inte margarin', is_completed: 0, category_id: 2 }
    ]

    todos.each do |todo|
      db.execute('INSERT INTO todos (todo_title, todo_description, is_completed, category_id) VALUES (?,?,?,?)',
                 [todo[:todo_title], todo[:todo_description], todo[:is_completed], todo[:category_id]])
    end
  end
end
