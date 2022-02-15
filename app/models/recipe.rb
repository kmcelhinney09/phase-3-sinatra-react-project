class Recipe < ActiveRecord::Base
    has_many :reviews
    has_many :user_recipe_boxes
    has_many :users, through: :user_recipe_boxes
end