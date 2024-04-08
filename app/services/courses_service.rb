class CoursesService
  def initialize(user)
    @user = user
  end
  PAGE = 1
  def page
    @params[:page]&.to_i || PAGE
  end

  PER_PAGE_DEF = 10
  def per_page
    @params[:per_page]&.to_i || PER_PAGE_DEF
  end

  def limit
    page
  end

  def offset
    (page - 1) * per_page
  end

  def index(params)
    @params = params
    if params[:student_id] and params[:tutor_id]
      courses_with_student = Course.joins(:enrollments).where(enrollments: { user_id: params[:student_id] }).where(user_id: params[:tutor_id]).limit(limit).offset(offset).pluck(:title, :description, :user_id)
      @courses = courses_with_student.where(user_id: params[:tutor_id]).limit(limit).offset(offset).pluck(:title, :description, :user_id)
      @courses = @courses.map { |title, description, user_id| { student: User.find(params[:student_id]).fullname, title: title, description: description, creator: User.find(user_id).fullname } }.as_json

    elsif params[:tutor_id]
      @courses = Course.where(user_id: params[:tutor_id]).limit(limit).offset(offset).pluck(:title, :description, :user_id)
      @courses = @courses.map { |title, description, user_id| { title: title, description: description, creator: User.find(user_id).fullname } }.as_json
    elsif params[:student_id]
      @courses = Course.where(id: Enrollment.where(user_id: params[:student_id]).limit(limit).offset(offset).pluck(:course_id)).pluck(:title, :description, :user_id)
      @courses = @courses.map { |title, description, user_id| { student: User.find(params[:student_id]).fullname, title: title, description: description, creator: User.find(user_id).fullname } }.as_json
    elsif not params[:student_id] and not params[:tutor_id]
      @courses = Course.all.limit(limit).offset(offset).pluck(:title, :description, :user_id)
      @courses = @courses.map {|title, description, user_id| {title: title, description: description, creator: User.find(user_id).fullname}}.as_json
    end
    @courses
  end

  def create_course(token, course_params)
    return [1, { error: "401 Unauthorised", status: 401}] if token.eql? nil
    return [1, { error: "401 Unauthorised", status: 401}] if @user.validation_jwt.eql? nil
    return [1, { error: "403 Forbidden" , status: :forbidden}] unless token[0]["root"].eql? 2
    @course = @user.courses.new(title: course_params[:title], description: course_params[:description])
    return [0, { description: course_params[:description], fullname: @user.fullname}, :ok] if @course.save
    [1, {error: @course.errors, status: :unprocessable_entity}]
  end

  def subscribe(token, params)
    return [1, { error: "401 Unauthorised", status: 401}] if token.eql? nil
    return [1, { error: "401 Unauthorised", status: 401}] if @user.validation_jwt.eql? nil
    return [1, {error: "403 Forbidden", status: 403}] unless @user.root.eql? 1
    course = Course.find_by(id: params[:id])
    return [1, {error: "Course was not found", status: :unprocessable_entity}] unless course
    enrollment = @user.enrollments.create(course_id: params[:id])
    return [0, :ok] if enrollment.save
    [1, { error: enrollment.errors, status: :unprocessable_entity}]
  end

  def show(params)
    course = Course.find_by(id: params[:id])
    return {} unless course
    ids = []
    Enrollment.where(course_id: course.id).each do |enrollment|
      ids.append(enrollment.user_id)
    end
    students = User.where(id: ids)
    { json: { title: course.title, description: course.description, fullname: User.find(course.user_id).fullname, students: students.pluck(:fullname)}}
  end
end