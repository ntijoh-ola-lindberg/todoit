require_relative 'base_model'

class Todo < BaseModel

  def self.all()
    sql_todos = 'SELECT todos.*, categories.category_title
            FROM todos
	            INNER JOIN categories
		            ON category_id = categories.id'

    todos = db.execute(sql_todos)
    return todos
  end

  def self.create(title, description, is_completed, category_id)
    db.execute(
      'INSERT INTO todos (todo_title, todo_description,
                          is_completed, category_id)
                            VALUES (?,?,?,?)', [title, description, is_completed, category_id]
    )
  end

  def self.find(id)
    sql_todos = 'SELECT todos.*, categories.category_title
            FROM todos
	            INNER JOIN categories
		            ON category_id = categories.id
            WHERE todos.id = ?'

    todo = db.execute(sql_todos, id).first
    ap "Todo.find(id): #{todo}"
    return todo
  end

  def self.update(id, title, description, is_completed, category_id)
    sql_save_todo = 'UPDATE todos SET todo_title =?, todo_description =?, is_completed=?, category_id=? WHERE id=?'
    db.execute(sql_save_todo, [title, description, is_completed, category_id, id])
  end


end