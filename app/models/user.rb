require 'bcrypt'

class User < ActiveRecord::Base
    has_many :reviews
    has_many :user_recipe_boxes
    has_many :recipes, through: :user_recipe_boxes
    has_secure_password
end