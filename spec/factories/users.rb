FactoryBot.define do
  factory :user do
    fullname { "Учитель1" }
    email { "email_teacher1@mail.ru" }
    password { 'password1' }
    root { 2 }
  end
end