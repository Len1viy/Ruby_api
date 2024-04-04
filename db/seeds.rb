# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Enrollment.destroy_all
Course.destroy_all
User.destroy_all


User.create(fullname: "Учитель1", email: "email_teacher1@mail.ru", password: BCrypt::Password.create("password1"), root: 2)
User.create(fullname: "Учитель2", email: "email_teacher2@mail.ru", password: BCrypt::Password.create("password2"), root: 2)
User.create(fullname: "Ученик1", email: "email_student1@mail.ru", password: BCrypt::Password.create("password3"), root: 1)
User.create(fullname: "Ученик2", email: "email_student2@mail.ru", password: BCrypt::Password.create("password4"), root: 1)

