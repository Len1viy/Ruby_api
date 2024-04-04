require 'jwt'
class Api::CoursesController < ApplicationController
  def index
    if params[:page]
      page = params[:page].to_i
      if not params[:per_page]
        per_page = 10
      else
        per_page = params[:per_page].to_i
      end
      offset = (page - 1) * per_page
      limit = per_page
    end
    if params[:student_id] and params[:tutor_id]
      courses_for_check = Enrollment.where(user_id: params[:student_id])
      courses_with_student = Course.where(id: courses_for_check.pluck(:course_id))
      @courses = courses_with_student.where(user_id: params[:tutor_id]).limit(limit).offset(offset).pluck(:title, :description, :user_id)
      @courses = @courses.map { |title, description, user_id| { student: User.find(params[:student_id]).fullname, title: title, description: description, creator: User.find(user_id).fullname } }.as_json

    elsif params[:tutor_id]
      @courses = Course.where(user_id: params[:tutor_id]).limit(limit).offset(offset).pluck(:title, :description, :user_id)
      @courses = @courses.map { |title, description, user_id| { title: title, description: description, creator: User.find(user_id).fullname } }.as_json
    elsif params[:student_id]
      @courses = Course.where(id: Enrollment.where(user_id: params[:student_id]).limit(limit).offset(offset).pluck(:course_id)).pluck(:title, :description, :user_id)
      @courses = @courses.map { |title, description, user_id| { student: User.find(params[:student_id]).fullname, title: title, description: description, creator: User.find(user_id).fullname } }.as_json
      # @courses = Course.where(id: Enrollment.where(user_id: params[:id_student]))
    elsif not params[:student_id] and not params[:tutor_id]
      @courses = Course.all.limit(limit).offset(offset).pluck(:title, :description, :user_id)
      @courses = @courses.map {|title, description, user_id| {title: title, description: description, creator: User.find(user_id).fullname}}.as_json
    end

    render json: @courses
    end


  def show
    puts Course.all
    @course = Course.find_by(id: params[:id])
    if @course
      ids = []

      Enrollment.where(course_id: @course.id).each do |enrollment|
        ids.append(enrollment.user_id)
      end
      students = User.where(id: ids)
      render json: {title: @course.title, description: @course.description, fullname: User.find(@course.user_id).fullname, students: students.pluck(:fullname)}
    else
      render json: {}
    end
  end

  def subscribe
    decoded_token = JWT.decode(request.headers['Authorization'][7..-1], "SK", false, {algorithm: "HS256"})
    user = User.find(decoded_token[0]["id"])
    if user.root.eql? 1 and user.validation_jwt != nil
      course = Course.find_by(id: params[:id])
      if course
        enrollment = user.enrollments.create(course_id: params[:id])
        if enrollment.save
          render json: {}, status: :ok
        else
          render json: enrollment.errors, status: :unprocessable_entity
        end
      else
        render json: {error: "Course was not found"}, status: :unprocessable_entity
      end
    else
      render json: {}, status: :forbidden
    end

  end

  def create
    decoded_token = JWT.decode(request.headers['Authorization'][7..-1], "SK", false, {algorithm: "HS256"})
    user = User.find_by(id: decoded_token[0]["id"], email: decoded_token[0]["email"])
    if user&.validation_jwt
      if decoded_token[0]["root"].eql? 2

        @course = user.courses.new(title: course_params[:title], description: course_params[:description])
        if @course.save
          render json: { description: course_params[:description], fullname: user.fullname }, status: :ok
        else
          render json: @course.errors, status: :unprocessable_entity
        end
      else
        render json: {error: "403 Forbidden"},  status: :forbidden
      end
    else
      render json: {error: "401 Unauthorised"},  status: 401
    end
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
