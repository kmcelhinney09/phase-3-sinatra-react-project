require "json"

def get_category_id(name_of_category)
  Category.find_or_create_by(category_name: name_of_category).id
end

class ApplicationController < Sinatra::Base
  set :default_content_type, "application/json"

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
                     reviews: { except: [:recipe_id], include: {
                       user: { only: [:name] },
                     } },
                   }, { recipe_ingredients: { only: [:quantity, :units], include: { ingredient: { only: [:ingredient_name, :cal_per_serving] } } } }, { category: { only: [:category_name] } }])
  end

  post "/recipes" do
    category_id_lookup = get_category_id(params[:category_name])

    new_recipe = Recipe.create(
      recipe_name: params[:recipe_name],
      serving_size: params[:serving_size],
      cal_per_serving: params[:cal_per_serving],
      category_id: category_id_lookup,
      directions: params[:directions],
      creator_id: params[:creator_id],
      img_url: params[:img_url],
    )

    ingredients = params[:ingredients].to_json
    ingredients_parse = JSON.parse(ingredients)
    ingredients_parse.each do |ingredient|
      ingredient_name_given = ingredient["ingredient_name"]
      ingredient_calories = ingredient["cal_per_serving"]
      ingredient_quantity = ingredient["quantity"]
      ingredient_units = ingredient["units"]
      ingredient_data = Ingredient.find_or_create_by(ingredient_name: ingredient_name_given) do |ingredient|
        ingredient.cal_per_serving = ingredient_calories
      end

      RecipeIngredient.create(recipe_id: new_recipe.id,
                              ingredient_id: ingredient_data.id, quantity: ingredient_quantity, units: ingredient_units)
    end
    UserRecipeBox.create(user_id: params[:creator_id], recipe_id: new_recipe.id)
    new_recipe.to_json
  end

  patch "/recipes/:id" do
    recipe_update = Recipe.find(params[:id])

    category_id_lookup = get_category_id(params[:category_name])
    recipe_ingredients = recipe_update.ingredients
    # recipe_ingredients_names = recipe_ingredients.map{|ingredient| ingredient.ingredient_name}
    # pp recipe_ingredients_names
  
    recipe_update.update(
      recipe_name: params[:recipe_name],
      serving_size: params[:serving_size],
      cal_per_serving: params[:cal_per_serving],
      category_id: category_id_lookup,
    )

    ingredients = params[:ingredients].to_json
    ingredients_parse = JSON.parse(ingredients)
    new_ingredient_names = []
    ingredients_parse.each do |ingredient|
      ingredient_name_given = ingredient["ingredient_name"]
      new_ingredient_names.push(ingredient_name_given)
      ingredient_calories = ingredient["cal_per_serving"]
      ingredient_quantity = ingredient["quantity"]
      ingredient_units = ingredient["units"]
      ingredient_data = Ingredient.find_or_create_by(ingredient_name: ingredient_name_given)
      if ingredient_data.cal_per_serving != ingredient_calories
        ingredient_data.update(cal_per_serving: ingredient_calories)
      end
      recipe_ingredient_connection = RecipeIngredient.find_or_create_by(recipe_id: recipe_update.id, ingredient_id: ingredient_data.id)
      puts "Recipe Units"
      puts recipe_ingredient_connection.units
      if recipe_ingredient_connection.quantity != ingredient_quantity
        recipe_ingredient_connection.update(quantity: ingredient_quantity)
      end
      if recipe_ingredient_connection.units != ingredient_units or recipe_ingredient_connection.units.nil?
        recipe_ingredient_connection.update(units: ingredient_units)
      end
    end
    recipe_ingredients.each do |ingredients|
      if new_ingredient_names.exclude? ingredients.ingredient_name
        recipe_ingredient_connection = RecipeIngredient.where(recipe_id: recipe_update.id, ingredient_id:ingredients.id)[0]
        recipe_ingredient_connection.destroy
      end
    end
    recipe_update.to_json
  end

  delete "/recipes/:id" do
    recipe_delete = Recipe.find(params[:id])
    all_ingredients_connection = RecipeIngredient.where(recipe_id: recipe_delete.id)
    all_ingredients_connection.each do |connection|
      connection.destroy
    end
    recipe_delete.destroy

    recipe_delete.to_json
  end

  get "/recipes/ingredient/:ingredient_name" do
    ingredient_name = params[:ingredient_name].titleize
    search_ingredient = Ingredient.find_by(ingredient_name: ingredient_name)
    found_recipies = search_ingredient.recipes
    found_recipies.to_json(only: [:recipe_name, :id, :serving_size, :cal_per_serving, :img_url, :updated_at], include: { recipe_ingredients: { only: [:id] }, category: {} })
  end

  get "/users/:id" do
    user = User.find(params[:id])
    user.to_json(only: [:name])
  end

  post "/users/new" do
    user = User.find_by(login_id: params[:login_id])

    if user.nil?
      new_user = User.create(
        name: params[:name],
        password: params[:password],
        login_id: params[:login_id],
        last_logged_in: DateTime.now,
      )
      return new_user.to_json(only: [:name, :id, :login_id])
    else
      message = { error: "Email already in use" }
      return message.to_json
    end
  end

  post "/users/login" do
    user = User.find_by(login_id: params[:login_id])
    authentication = user.authenticate(params[:password])
    authentication.to_json(except: [:password_digest])
  end

  patch "/users/:id" do
    user = User.find(params[:id])
    user.update(
      name: params[:name],
      login_id: params[:login_id],
    )

    user.to_json(only: [:name, :id, :login_id])
  end

  patch "/users/:id/update_password" do
    user = User.find(params[:id])
    if user.authenticate(params[:current_password])
      user.update(password: params[:new_password])
    end
    user.to_json(only: [:name, :id, :login_id])
  end

  delete "/users/:id" do
    user = User.find(params[:id])
    user.destroy
    user.to_json(only: [:name, :id, :login_id])
  end

  post "/reviews" do
    review = Review.create(
      user_id: params[:user_id],
      recipe_id: params[:recipe_id],
      review_text: params[:review_text],
    )
    review.to_json
  end

  patch "/reviews/:id" do
    review = Review.find(params[:id])
    review.update(
      review_text: params[:review_text],
    )
    review.to_json
  end

  delete "/reviews/:id" do
    review = Review.find(params[:id])
    review.destroy
    review.to_json
  end

  get "/categories" do
    categories = Category.all
    categories.to_json
  end

  get "/categories/:id" do
    recipe_by_category = Recipe.where(category_id: params[:id]).all
    recipe_by_category.to_json(only: [:recipe_name, :id, :serving_size, :cal_per_serving, :img_url, :updated_at], include: { recipe_ingredients: { only: [:id] }, category: {} })
  end

  get "/users/:id/recipe_box" do
    user = User.find(params[:id])
    user_recipe_box = user.recipes
    user_recipe_box.to_json(only: [:recipe_name, :id, :serving_size, :cal_per_serving, :img_url, :updated_at, :category_id], include: { recipe_ingredients: { only: [:id] }, category: {only:[:category_name]} })
  end

  post "/users/:id/recipe_box" do
    connection = UserRecipeBox.where(user_id: params[:id], recipe_id: params[:recipe_id])[0]
    puts "Hey its a connection"
    puts connection.to_json
    if connection.nil?
      user_recipe_connection = UserRecipeBox.create(user_id: params[:id], recipe_id: params[:recipe_id])
    else
      user_recipe_connection = { error: "Already in your recipe box" }
    end
    user_recipe_connection.to_json
  end

  delete "/users/:id/recipe_box/:recipe_id" do
    connection = UserRecipeBox.where(user_id: params[:id], recipe_id: params[:recipe_id])[0]
    connection.destroy
    connection.to_json
  end
end
