class UpdateUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :user_name, :name
    add_column :users, :user_id, :string
  end
end
