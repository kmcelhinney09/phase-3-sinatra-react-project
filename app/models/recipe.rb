class Recipe < ActiveRecord::Base
    belongs_to :category
    has_many :reviews
    has_many :user_recipe_boxes
    has_many :users, through: :user_recipe_boxes
    has_many :recipe_ingredients
    has_many :ingredients, through: :recipe_ingredients
end