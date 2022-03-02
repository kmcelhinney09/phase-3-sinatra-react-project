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
  
  get '/recipes/ingredient/:id' do
    search_ingredient = Ingredient.find(params[:id])
    recipies = search_ingredient.recipes
    recipies.to_json
  end

  get '/users/:id' do
    user = User.find(params[:id])
    user.to_json(only: [:name])
  end

  post '/users/new' do
    user = User.create(
      name:params[:name],
      password:params[:password],
      login_id:params[:login_id],
      last_logged_in: DateTime.now
    )

    user.to_json(only: [:name, :id, :login_id])
  end

  post '/users/login' do
    user = User.find_by(login_id:params[:login_id])
    authentication = user.authenticate(params[:password])
    authentication.to_json(except: [:password_digest])
  end

  patch '/users/:id' do
    user = User.find(params[:id])
    user.update(
      name:params[:name],
      login_id:params[:login_id]
    )

    user.to_json(only: [:name, :id, :login_id])
  end

  patch '/users/:id/update_password' do
    user = User.find(params[:id])
    if user.authenticate(params[:current_password])
      user.update(password:params[:new_password])
    end
    user.to_json(only: [:name, :id, :login_id])
  end

  delete '/users/:id' do
    user = User.find(params[:id])
    user.destroy
    user.to_json(only: [:name, :id, :login_id])
  end

  get '/reviews' do
    reviews = Review.all
    reviews.to_json
  end

  get '/reviews/:id' do
    review = Review.find(params[:id])
    review.to_json
  end

  post '/reviews' do
    review = Review.create(
      user_id:params[:user_id],
      recipe_id:params[:recipe_id],
      review_text:params[:review_text]
    )
    review.to_json
  end

  patch '/reviews/:id' do
    review = Review.find(params[:id])
    review.update(
      review_text: params[:review_text]
    )
    review.to_json
  end

  delete '/reviews/:id' do
    review = Review.find(params[:id])
    review.destroy
    review.to_json
  end

  get '/categories' do
    categories = Category.all
    categories.to_json
  end

  get '/categories/:id' do
    recipe_by_category = Recipe.where(category_id:params[:id]).all
    recipe_by_category.to_json
  end

  post '/categories' do
    category = Category.create(
      category_name:params[:category_name]
    )
    category.to_json
  end

  delete '/categories/:id' do
    category = Category.find(params[:id])
    category.destroy
    category.to_json
  end


  get '/ingredients' do
    ingredients = Ingredient.all
    ingredients.to_json
  end

  get '/ingredients/:id' do
    ingredient = Ingredient.find(params[:id])
    ingredient.to_json
  end


  get '/users/:id/recipe_box' do
    user =  User.find(params[:id])
    user_recipe_box = user.recipes
    user_recipe_box.to_json(except: [:id], include: [{
      reviews: { except:[:id, :recipe_id,:user_id], include:{
        user: {only: [:name]}
      }}},{recipe_ingredients: {only: [:quantity, :units], include:{ingredient: {only:[:ingredient_name, :cal_per_serving]}}}},{category: {only: [:category_name]}}]
    )
  end

  post '/users/:id/recipe_box' do
    connection = UserRecipeBox.where(user_id:params[:id], recipe_id:params[:recipe_id])[0]
    if connection == "null"
      user_recipe_connection = UserRecipeBox.create(user_id:params[:id], recipe_id:params[:recipe_id])
    else
      user_recipe_connection = {error:"Already in your recipe box"}
    end
    user_recipe_connection.to_json
  end

  delete '/users/:id/recipe_box/:recipe_id' do
    connection = UserRecipeBox.where(user_id:params[:id], recipe_id:params[:recipe_id])[0]
    connection.destroy
    connection.to_json
  end

end


