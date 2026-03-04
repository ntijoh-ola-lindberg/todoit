class Todo

  def self.db
    return @db if @db

    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true

    @db
  end


  def self.all()
    sql_todos = 'SELECT todos.*, categories.category_title
            FROM todos
	            INNER JOIN categories
		            ON category_id = categories.id'

    todos = db.execute(sql_todos)
    return todos
  end


end