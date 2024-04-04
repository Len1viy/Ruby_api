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

ActiveRecord::Schema[7.1].define(version: 2024_04_04_152000) do
  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "fullname"
    t.string "email"
    t.string "password"
    t.integer "root"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "validation_jwt"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "courses", "users"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
end
