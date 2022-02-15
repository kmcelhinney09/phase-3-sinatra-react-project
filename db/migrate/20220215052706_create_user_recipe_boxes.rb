class CreateUserRecipeBoxes < ActiveRecord::Migration[6.1]
  def change
    create_table :user_recipe_boxes do |t|
      t.integer :user_id
      t.integer :recipe_id
    end
  end
end
