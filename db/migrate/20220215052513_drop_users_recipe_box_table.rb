class DropUsersRecipeBoxTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :user_recipe_box
  end
end
