class CreateUsersRecipeBox < ActiveRecord::Migration[6.1]
  def change
    create_table :user_recipe_box do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.timestamps
    end
  end
end
