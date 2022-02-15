puts "🌱 Seeding spices..."

10.times do
    User.create(
        user_name:Faker::Name.name,
        password:Faker::Alphanumeric.alpha(number: 10),
        last_logged_in:Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
    )
end

10.times do
    Recipe.create(
        recipe_name:Faker::Food.dish,
        serving_size:rand(1...20),
        cal_per_serving:rand(100...1000)
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

puts "✅ Done seeding!"
