class ChangeUserColumnUserId < ActiveRecord::Migration[6.1]
  def change
    rename_column(:users, :user_id, :login_id)
  end
end
