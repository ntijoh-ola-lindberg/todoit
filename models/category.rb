require_relative 'base_model'

class Category < BaseModel

  def self.all()
    sql_categories = 'SELECT * FROM categories'
    categories = db.execute(sql_categories)
    return categories
  end

end