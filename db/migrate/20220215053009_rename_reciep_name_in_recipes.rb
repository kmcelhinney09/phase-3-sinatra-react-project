class RenameReciepNameInRecipes < ActiveRecord::Migration[6.1]
  def change
    change_table :recipes do |t|
      t.rename :reciep_name, :recipe_name
    end
  end
end
