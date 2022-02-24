class ChangeColumnNameCatagories < ActiveRecord::Migration[6.1]
  def change
    rename_column(:catagories, :catafory_name, :category_name)
    rename_table(:catagories, :categories)
  end
end
