class Api::RegistrationController < ApplicationController

  def index
    @users = User.all
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  def user_params
    # puts params
    if params[:user].is_a? String
      params[:user]
    else
      params.require(:user).permit(:fullname, :email, :password, :root)
    end
  end
end
