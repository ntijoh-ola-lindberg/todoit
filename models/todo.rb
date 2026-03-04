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
    return todo
  end

  def self.update(id, title, description, is_completed, category_id)
    sql_save_todo = 'UPDATE todos SET todo_title =?, todo_description =?, is_completed=?, category_id=? WHERE id=?'
    db.execute(sql_save_todo, [title, description, is_completed, category_id, id])
  end

  def self.destroy(id)
    db.execute('DELETE FROM todos WHERE id =?', id)
  end

  def self.all_by_category_id(category_id)
    sql_todos = 'SELECT todos.*, categories.category_title
                  FROM todos
	                  INNER JOIN categories
		                  ON todos.category_id = categories.id
                  WHERE todos.category_id=?'
    todos = db.execute(sql_todos, category_id)
    return todos
  end

  def self.toggle_completion(id)
    sql = 'UPDATE todos SET is_completed = 1 - is_completed WHERE id = ?'
    db.execute(sql, id)
  end

  #sql = 'UPDATE todos SET is_completed = ((is_completed | 1) - (is_completed & 1)) WHERE id =?'

end