require 'jwt'
require 'bcrypt'
class Api::SessionController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :set_access_control_headers

  def index
    render json: @users, status: :ok
  end

  def show
    render json: @user
  end

  def create
    user = User.find_by(email: user_params[:email])
    if user
      if BCrypt::Password.new(user.password) == user_params[:password]
        payload = { id: user.id, email: user_params[:email], password: user_params[:password], root: user.root, created_at: Time.now()}
        token = (JWT.encode payload, "SK", "HS256")[0..-2]
        user.validation_jwt = SecureRandom.hex(8)
        user.save
        render json: { jwt: token }, status: :ok
      else
        render json: {error: "Wrong email or password"}, status: :unauthorized
      end
    else
      puts "Here"
      render json: {error: "Wrong email or password"}, status: :unauthorized
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teachers/1
  def destroy
    decoded_token = JWT.decode(request.headers['Authorization'][7..-1], "SK", false, {algorithm: "HS256"})
    @user = User.find_by(id: decoded_token[0]["id"], email: decoded_token[0]["email"])
    if @user and @user.validation_jwt != nil
      @user.validation_jwt = nil
      @user.save
      render json: @user, status: :ok
    else
      render json: @user, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = User.all
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    # puts params
    if params[:user].is_a? String
      params[:user]
    else
      params.require(:user).permit(:email, :password)
    end
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type'
  end

end
