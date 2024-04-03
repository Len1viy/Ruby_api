require 'jwt'

class Api::SessionController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    payload = {email: user_params[:email], password: user_params[:password]}
    token = JWT.encode payload, nil, 'none'
    if @user.save
      render json: { jwt: token[0..-2]}
    else
      render json: @user.errors, status: :unprocessable_entity
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
    @user.destroy!
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
      params.require(:user).permit(:fullname, :email, :password, :roots)
    end
  end
end
