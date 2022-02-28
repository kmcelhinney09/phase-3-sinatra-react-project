class RecipesAddColumnDirections < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :directions, :text
  end
end
