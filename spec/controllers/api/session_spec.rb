require 'rails_helper'
require 'bcrypt'

RSpec.describe Api::SessionController, type: :request do
  let!(:user1) { FactoryBot.create(:user, fullname: "Учитель1",
                                  email: "email_teacher1@mail.ru",
                                  password: BCrypt::Password.create("password1"),
                                  root: 2,
                                  validation_jwt: nil) }
  let!(:user2) { FactoryBot.create(:user, fullname: "Ученик1",
                                   email: "email_student1@mail.ru",
                                   password: BCrypt::Password.create("password2"),
                                   root: 1,
                                   validation_jwt: nil) }
  let!(:user3) { FactoryBot.create(:user, fullname: "Ученик2",
                                   email: "email_student2@mail.ru",
                                   password: BCrypt::Password.create("password3"),
                                   root: 1,
                                   validation_jwt: nil) }
  let(:token1) { JWT.encode({ id: user1.id,
                             email: "email_teacher1@mail.ru",
                             password: BCrypt::Password.create("password1"),
                             root: 2,
                             created_at: Time.now() },
                           "SK",
                           "HS256") }
  let(:token2) { JWT.encode({ id: user2.id,
                              email: "email_student1@mail.ru",
                              password: BCrypt::Password.create("password2"),
                              root: 1,
                              created_at: Time.now() },
                            "SK",
                            "HS256") }
  let(:token3) { JWT.encode({ id: user3.id,
                              email: "email_student2@mail.ru",
                              password: BCrypt::Password.create("password3"),
                              root: 1,
                              created_at: Time.now() },
                            "SK",
                            "HS256") }
  it "POST api/session tutor" do
    post "/api/session", params: {user: {email: "email_teacher1@mail.ru", password: "password1"}}
    expect(response).to have_http_status(:ok)
    decoded_token = JWT.decode(JSON.parse(response.body)["jwt"], "SK", false, {algorithm: "HS256"})
    expect(decoded_token[0]["id"]).to eq user1.id
    expect(decoded_token[0]["email"]).to eq user1.email
    expect(decoded_token[0]["root"]).to eq user1.root
  end

  it "DELETE api/session" do
    delete "/api/session", params: {},
           headers: {'Authorization': "Bearer #{token1}" }
    expect(user1.validation_jwt).to eq nil
  end

  it "POST api/session student" do
    post "/api/session", params: {user: {email: "email_student1@mail.ru", password: "password2"}}
    expect(response).to have_http_status(:ok)
    decoded_token = JWT.decode(JSON.parse(response.body)["jwt"], "SK", false, {algorithm: "HS256"})
    expect(decoded_token[0]["id"]).to eq user2.id
    expect(decoded_token[0]["email"]).to eq user2.email
    expect(decoded_token[0]["root"]).to eq user2.root
  end

  it "POST api/session student2" do
    post "/api/session", params: {user: {email: "email_student2@mail.ru", password: "password3"}}
    expect(response).to have_http_status(:ok)
    decoded_token = JWT.decode(JSON.parse(response.body)["jwt"], "SK", false, {algorithm: "HS256"})
    expect(decoded_token[0]["id"]).to eq user3.id
    expect(decoded_token[0]["email"]).to eq user3.email
    expect(decoded_token[0]["root"]).to eq user3.root
  end
end
