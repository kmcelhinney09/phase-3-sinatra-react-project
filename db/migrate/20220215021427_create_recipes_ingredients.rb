class CreateRecipesIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes_ingredients do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
    end
  end
end
