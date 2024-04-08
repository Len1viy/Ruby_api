require 'jwt'
class Api::CoursesController < ApplicationController
  before_action :check_user_auth
  before_action :create_service

  def index
    render json: @service.index(params)
    end


  def show
    ans = @service.show(params)
    puts ans
    render json: ans[:json] if ans.key?(:json)
    render {} unless ans.key?(:json)
  end

  def subscribe
    ans = @service.subscribe(@token, params)
    render json: {error: ans[1][:error]},  status: ans[1][:status] if ans[0].eql? 1
    render json: {}, status: ans[1]
  end

  def create
    ans = @service.create_course(@token, course_params)
    render json: {error: ans[1][:error]},  status: ans[1][:status] if ans[0].eql? 1
    render json: ans[1], status: ans[2] if ans[0].eql? 0
  end

  private

  def check_user_auth
    return if request.eql? nil
    return unless request.headers.key?(:Authorization)
    decoded_token = JWT.decode(request.headers['Authorization'][7..-1], "SK", false, {algorithm: "HS256"})
    user = User.find_by(id: decoded_token[0]["id"], email: decoded_token[0]["email"])
    if user&.validation_jwt
      @token = decoded_token
      @user = user
    end
  end

  def create_service
    @service = CoursesService.new(@user) if @user
    render json: {error: "User doesn't exist"}, status: :unauthorized unless @user
  end

  def course_params
    params[:course] if params[:course].is_a? String
    params.require(:course).permit(:title, :description) unless params[:course].is_a? String
  end
end
