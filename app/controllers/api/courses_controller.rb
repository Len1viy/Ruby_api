class Api::CoursesController < ApplicationController
  def index
    @courses = Course.all
    render json: @courses
  end

  def create

  end


  private
  def couse_params
    if params[:course].is_a? String
      params[:course]
    else
      params.require(:course).permit(:title, :description, :creator)
    end
end
