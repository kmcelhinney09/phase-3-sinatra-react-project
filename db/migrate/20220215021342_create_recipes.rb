class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :reciep_name
      t.integer :serving_size
      t.integer :cal_per_serving
      t.integer :catagory_id
      t.timestamps
    end
  end
end
