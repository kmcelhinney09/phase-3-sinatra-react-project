# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_27_234628) do

  create_table "categories", force: :cascade do |t|
    t.string "category_name"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "ingredient_name"
    t.integer "cal_per_serving"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "ingredient_id"
    t.float "quantity"
    t.string "units"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "recipe_name"
    t.integer "serving_size"
    t.integer "cal_per_serving"
    t.integer "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipe_id"
    t.text "review_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_recipe_boxes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "recipe_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "last_logged_in"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_id"
  end

end
