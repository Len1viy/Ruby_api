# require 'rails_helper'
# include Rails.application.routes.url_helpers
#
# RSpec.describe Api::CoursesController, Api::SessionController, type: :request do
#   let!(:user1) { FactoryBot.create(:user, fullname: "Учитель1",
#                                    email: "email_teacher1@mail.ru",
#                                    password: BCrypt::Password.create("password1"),
#                                    root: 2,
#                                    validation_jwt: SecureRandom.hex(8)) }
#   let!(:user2) { FactoryBot.create(:user, fullname: "Ученик1",
#                                    email: "email_student1@mail.ru",
#                                    password: BCrypt::Password.create("password2"),
#                                    root: 1,
#                                    validation_jwt: SecureRandom.hex(8)) }
#   let!(:token1) { JWT.encode({ id: user1.id,
#                                email: "email_teacher1@mail.ru",
#                                password: BCrypt::Password.create("password1"),
#                                root: 2,
#                                created_at: Time.now() },
#                              "SK",
#                              "HS256") }
#   let!(:token2) { JWT.encode({ id: user2.id,
#                                email: "email_student1@mail.ru",
#                                password: BCrypt::Password.create("password2"),
#                                root: 1,
#                                created_at: Time.now() },
#                              "SK",
#                              "HS256") }
#
#   it "POST api/courses" do
#     ans_for_compare = { "description": "Nice subject", "fullname": "Учитель1" }
#     post "/api/courses",
#          params: { course: { title: "Math", description: "Nice subject" } }.to_json,
#          headers: { Authorization: "Bearer #{token1}", "Content-Type": "application/json" }
#     expect(response).to have_http_status(:ok)
#     expect(JSON.parse(response.body)["description"]).to eq ans_for_compare[:description]
#     expect(JSON.parse(response.body)["fullname"]).to eq ans_for_compare[:fullname]
#     expect(Course.find_by(user_id: user1.id).title).to eq "Math"
#     expect(Course.find_by(user_id: user1.id).description).to eq "Nice subject"
#
#   end
#
#
#
#   let!(:course) {FactoryBot.create(:course,
#                                    title: "Math",
#                                    description: "Nice subject",
#                                    user_id: user1.id)}
#
#
#   it "GET api/courses?tutor_id=1" do
#     ans_for_compare = [{"creator"=>"Учитель1", "description"=>"Nice subject", "title"=>"Math"}]
#
#     get "/api/courses?tutor_id=1"
#     expect(response).to have_http_status(:ok)
#     expect(JSON.parse(response.body)).to eq ans_for_compare
#   end
#
#
#   it "POST api/courses unauthorised" do
#     delete "/api/session", params: {},
#            headers: {'Authorization': "Bearer #{token1}" }
#     post "/api/courses",
#          params: { course: { title: "Math", description: "Nice subject" } }.to_json,
#          headers: { Authorization: "Bearer #{token1}", "Content-Type": "application/json" }
#     expect(response).to have_http_status(401)
#   end
#
#   it "POST api/courses forbidden and GET api/courses" do
#     post "/api/courses",
#          params: { course: { title: "Math", description: "Nice subject" } }.to_json,
#          headers: { Authorization: "Bearer #{token2}", "Content-Type": "application/json" }
#     expect(response).to have_http_status(403)
#     expect(Course.count).to eq 1
#     ans_for_compare = [{"creator"=>"Учитель1", "description"=>"Nice subject", "title"=>"Math"}]
#
#     get "/api/courses"
#     expect(response).to have_http_status(:ok)
#     expect(JSON.parse(response.body)).to eq ans_for_compare
#   end
# end
