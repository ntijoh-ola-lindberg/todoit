require_relative 'base_model'

class Category < BaseModel

  def self.all()
    sql_categories = 'SELECT * FROM categories'
    categories = db.execute(sql_categories)
    return categories
  end

  def self.find(id)
    sql_categories = 'SELECT * FROM categories WHERE id =?'
    category = db.execute(sql_categories, id).first
    return category
  end

  def self.find_by_title(title)
    category = db.execute('SELECT * FROM categories WHERE category_title LIKE ?', title).first
    return category
  end

end