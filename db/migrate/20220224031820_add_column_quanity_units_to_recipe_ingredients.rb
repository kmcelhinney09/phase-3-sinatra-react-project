class AddColumnQuanityUnitsToRecipeIngredients < ActiveRecord::Migration[6.1]
  def change
    add_column :recipe_ingredients, :quantity, :float
    add_column :recipe_ingredients, :units, :string
  end
end
