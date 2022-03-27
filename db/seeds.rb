puts "🌱 Seeding spices..."

User.create(
  name: "Kevin McElhinney",
  password: "Deniece09!",
  login_id: "mr.mcelhinney@gmail.com",
  last_logged_in: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
)

# 10.times do
#     User.create(
#         name:Faker::Name.name,
#         password:"password",
#         login_id:Faker::Internet.email,
#         last_logged_in:Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
#     )
# end

Recipe.create(
  recipe_name: "No Bake Cookies",
  serving_size: 24,
  cal_per_serving: 300,
  directions: "Mix oatmeal and melted chocolate then let set",
  category_id: 1,
  creator_id: 1,
  img_url: "https://www.cookingclassy.com/wp-content/uploads/2012/06/no-bake-cookies-77.jpg",
)
# 10.times do
#     Recipe.create(
#         recipe_name:Faker::Food.dish,
#         serving_size:rand(1...20),
#         cal_per_serving:rand(100...1000),
#         directions:Faker::Lorem.paragraph(sentence_count: 20, supplemental: false, random_sentences_to_add: 4),
#         category_id:rand(1..10),
#         creator_id:rand(1..10),
#         img_url:Faker::LoremFlickr.image(size:"150x300", search_terms:['food'])
#     )
# end
# Review.create(
#     user_id:rand(1..10),
#         recipe_id:1,
#         review_text:Faker::Movies::BackToTheFuture.quote
# )

# 10.times do
#     Review.create(
#         user_id:rand(1..10),
#         recipe_id:rand(1..10),
#         review_text:Faker::Movies::BackToTheFuture.quote

#     )
# end
UserRecipeBox.create(
  user_id: 1,
  recipe_id: 1,
)

# 10.times do
#     UserRecipeBox.create(
#         user_id:rand(1..10),
#         recipe_id:rand(1..10)
#     )
# end

Ingredient.create(
  ingredient_name: "Chocolate",
  cal_per_serving: 30,
)

# 10.times do
#     Ingredient.create(
#         ingredient_name:Faker::Food.ingredient,
#         cal_per_serving:rand(1..1000)
#     )
# end

RecipeIngredient.create(
  recipe_id: 1,
  ingredient_id: 1,
  quantity: 2,
  units: "cups",
)

# 10.times do
#     RecipeIngredient.create(
#         recipe_id:rand(1..10),
#         ingredient_id:rand(1..10),
#         quantity:rand(1.0..3.0).round(2),
#         units:(Faker::Food.measurement).split()[1]
#     )
# end

Category.create(
  category_name: "American",
)
# 9.times do
#     Category.create(
#         category_name:Faker::Food.ethnic_category

#     )
# end

puts "✅ Done seeding!"
