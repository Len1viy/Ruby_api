require 'jwt'
require 'bcrypt'
class Api::SessionController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :set_access_control_headers
  before_action :create_service
  def index
    render json: @users, status: :ok
  end

  def show
    render json: @user
  end

  def create
    ans =  @service.find_user(user_params)
    render json: {jwt: ans[:token]}, status: ans[:status] if ans[:status].eql? :ok
    render json: {error: ans[:error]}, status: ans[:status] unless ans[:status].eql? :ok
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
    ans = @service.unauth_user(request)
    render json: ans[0], status: ans[1]
  end




  private


  def create_service
    @service = SessionService.new
  end


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
