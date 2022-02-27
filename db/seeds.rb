puts "🌱 Seeding spices..."

10.times do
    User.create(
        user_name:Faker::Name.name,
        password:"password",
        last_logged_in:Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
    )
end

10.times do
    Recipe.create(
        recipe_name:Faker::Food.dish,
        serving_size:rand(1...20),
        cal_per_serving:rand(100...1000),
        category_id:rand(1..10)
    )
end

10.times do 
    Review.create(
        user_id:rand(1..10),
        recipe_id:rand(1..10),
        review_text:Faker::Movies::BackToTheFuture.quote
        
    )
end

10.times do
    UserRecipeBox.create(
        user_id:rand(1..10),
        recipe_id:rand(1..10)
    )
end

10.times do
    Ingredient.create(
        ingredient_name:Faker::Food.ingredient,
        cal_per_serving:rand(1..1000)
    )
end

10.times do
    RecipeIngredient.create(
        recipe_id:rand(1..10),
        ingredient_id:rand(1..10),
        quantity:rand(1.0..3.0).round(2),
        units:(Faker::Food.measurement).split()[1]
    )
end

Category.create(
    category_name:"American"
)
9.times do
    Category.create(
        category_name:Faker::Food.ethnic_category
        
    )
end


puts "✅ Done seeding!"
