class DropRecipesIngredientsTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :recipes_ingredients
  end
end
