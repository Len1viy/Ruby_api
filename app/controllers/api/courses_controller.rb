class Api::CoursesController < ApplicationController
  def index
    @courses = Course.all
    render json: @courses
  end

  def create
    # begin
    token = request.headers['Authorization'][7..-1]
    @user = User.find_by(id: Token.find_by(token: token).user_id)
    if @user.root.eql? 2
      @course = @user.courses.create(title: course_params[:title], description: course_params[:description])
      if @course.save
        render json: { description: course_params[:description], fullname: @user.fullname }, status: :ok
      else
        render json: @course.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "403 Forbidden"},  status: :forbidden
    end
    # rescue
    #   render json: user, status: :unprocessable_entity
    # end
  end

  private

  def course_params

    if params[:course].is_a? String
      params[:course]
    else
      params.require(:course).permit(:title, :description)
    end
  end
end
