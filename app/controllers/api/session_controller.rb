require 'jwt'

class Api::SessionController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :set_access_control_headers

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def create
    user = User.find_by(email: user_params[:email], password: user_params[:password])
    if user
      payload = {id: user.id, email: user_params[:email], password: user_params[:password]}
      token = (JWT.encode payload, "SK", "HS256")[0..-2]
      @token = user.tokens.create(token: token)
      if @token.save
        render json: { jwt: token }
      else
        render json: @token.errors, status: :unprocessable_entity
      end
    else
      render json: @token.errors, status: :unauthorized
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
    token = request.headers['Authorization'][7..-1]
    if Token.find_by(token: token)
      id = Token.find_by(token: token).user_id
      if id
        Token.where(user_id: id).destroy_all
        render json: id, status: :ok
      else
        render json: id, status: :unprocessable_entity
      end
    else
      render json: id, status: :unprocessable_entity
    end

    # Token.save
    # tokens_for_delete = Token.find_by(token)
    # @token.destroy!
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
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
