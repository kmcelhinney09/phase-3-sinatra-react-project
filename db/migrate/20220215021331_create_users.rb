class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :password
      t.datetime :last_logged_in
      t.timestamps 
    end
  end
end
