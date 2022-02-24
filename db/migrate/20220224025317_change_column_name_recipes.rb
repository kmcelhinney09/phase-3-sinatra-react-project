class ChangeColumnNameRecipes < ActiveRecord::Migration[6.1]
  def change
    rename_column(:recipes, :catagory_id, :category_id)
  end
end
