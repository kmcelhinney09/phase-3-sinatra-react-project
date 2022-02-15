class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.string :ingredient_name
      t.integer :cal_per_serving
      t.timestamps
    end
  end
end
