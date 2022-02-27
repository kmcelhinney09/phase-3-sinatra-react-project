require 'json'

def get_category_id(name_of_category)
  Category.find_by(category_name: name_of_category).id
end

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

  get "/recipes" do
    recipe = Recipe.all
    recipe.to_json
  end

  get "/recipes/:id" do
    recipe = Recipe.find(params[:id])
    recipe.to_json(except: [:id], include: [{
      reviews: { except:[:id, :recipe_id], include:{
        user: {only: [:user_name]}
      }}},{recipe_ingredients: {only: [:quantity, :units], include:{ingredient: {only:[:ingredient_name, :cal_per_serving]}}}},{category: {only: [:category_name]}}]
    )
  end

  post '/recipes' do
    
    category_id_lookup = get_category_id(params[:category_name])

    new_recipe = Recipe.create(
      recipe_name:params[:recipe_name],
      serving_size:params[:serving_size],
      cal_per_serving:params[:cal_per_serving],
      category_id: category_id_lookup
    )

    ingredients = params[:ingredients].to_json
    ingredients_parse = JSON.parse(ingredients)
    num_ingredients = ingredients_parse.keys
    num_ingredients.each do |ingredient|
      ingredient_name_given = ingredients_parse[ingredient]["ingredient_name"]
      ingredient_calories = ingredients_parse[ingredient]["cal_per_serving"]
      ingredient_quantity = ingredients_parse[ingredient]["quantity"]
      ingredient_units = ingredients_parse[ingredient]["units"]
      ingredient_data = Ingredient.find_or_create_by(ingredient_name:ingredient_name_given) do |ingredient|
        ingredient.cal_per_serving = ingredient_calories
      end

      RecipeIngredient.create(recipe_id:new_recipe.id, ingredient_id:ingredient_data.id, quantity:ingredient_quantity, units:ingredient_units)
    end
    new_recipe.to_json
  end

  patch '/recipes/:id' do
    recipe_update = Recipe.find(params[:id])

    category_id_lookup = get_category_id(params[:category_name])
    
    recipe_update.update(
      recipe_name:params[:recipe_name],
        serving_size:params[:serving_size],
        cal_per_serving:params[:cal_per_serving],
        category_id: category_id_lookup
    )
  
    ingredients = params[:ingredients].to_json
      ingredients_parse = JSON.parse(ingredients)
      num_ingredients = ingredients_parse.keys
      num_ingredients.each do |ingredient|
        ingredient_name_given = ingredients_parse[ingredient]["ingredient_name"]
        ingredient_calories = ingredients_parse[ingredient]["cal_per_serving"]
        ingredient_quantity = ingredients_parse[ingredient]["quantity"]
        ingredient_units = ingredients_parse[ingredient]["units"]
        ingredient_data = Ingredient.find_by(ingredient_name:ingredient_name_given)
        if ingredient_data.cal_per_serving != ingredient_calories
          ingredient_data.update(cal_per_serving:ingredient_calories)
        end
        recipe_ingredient_connection = RecipeIngredient.find_by(recipe_id:recipe_update.id, ingredient_id:ingredient_data.id)
        if recipe_ingredient_connection.quantity != ingredient_quantity
          recipe_ingredient_connection.update(quantity:ingredient_quantity)
        elsif recipe_ingredient_connection.units != ingredient_units
          recipe_ingredient_connection.update(units:ingredient_units)
        end
    end
    recipe_update.to_json
  end

  delete '/recipes/:id' do 
    recipe_delete = Recipe.find(params[:id])
    all_ingredients_connection = RecipeIngredient.where(recipe_id:recipe_delete.id)
    all_ingredients_connection.each do |connection|
      connection.destroy
    end
    recipe_delete.destroy

    recipe_delete.to_json
  end
  
  get '/users/:id' do
    user = User.find(params[:id])
    user.to_json
  end

  post '/users'do
    user = User.create(
      user_name:params[:user_name],
      password:params[:password],
      last_logged_in: DateTime.now
    )
    user.to_json(only: [:id, :user_name])
  end
end


