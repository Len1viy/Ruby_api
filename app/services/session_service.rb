require 'jwt'
require 'bcrypt'

class SessionService
  def initialize
  end

  def find_user(params)
    user = User.find_by(email: params[:email])
    return { error: "Wrong email or password", status: :unauthorized } unless user
    return { error: "Wrong email or password", status: :unauthorized } unless BCrypt::Password.new(user.password) == params[:password]
    payload = { id: user.id, email: params[:email], password: params[:password], root: user.root, created_at: Time.now() }
    token = (JWT.encode payload, "SK", "HS256")[0..-2]
    user.validation_jwt = SecureRandom.hex(8)
    user.save
    return { token: token, status: :ok }

  end

  def unauth_user(request)
    decoded_token = JWT.decode(request.headers['Authorization'][7..-1], "SK", false, { algorithm: "HS256" })
    @user = User.find_by(id: decoded_token[0]["id"], email: decoded_token[0]["email"])
    if @user and @user.validation_jwt != nil
      @user.validation_jwt = nil
      @user.save
      [@user, :ok]
    else
      [@user, :unprocessable_entity]
    end
  end
end