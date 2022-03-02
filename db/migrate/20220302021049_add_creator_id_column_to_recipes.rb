class AddCreatorIdColumnToRecipes < ActiveRecord::Migration[6.1]
  def change
    add_column :recipes, :creator_id, :integer
  end
end
