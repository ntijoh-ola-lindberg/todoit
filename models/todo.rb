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

  def self.create(title:, description:, is_completed:, category_id:)

    db.execute(
      'INSERT INTO todos (todo_title, todo_description,
                          is_completed, category_id)
                            VALUES (?,?,?,?)', [title, description, is_completed, category_id]
    )
  end


end