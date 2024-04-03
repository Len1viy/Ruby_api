require "test_helper"

class Api::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teacher = teachers(:one)
  end

  test "should get index" do
    get users_url, as: :json
    assert_response :success
  end

  test "should create teacher" do
    assert_difference("Teacher.count") do
      post users_url(@user), params: { user: { email: @user.email, fullname: @user.fullname, password: @user.password, roots: @user.roots } }, as: :json
    end

    assert_response :created
  end

  test "should show teacher" do
    get user_url(@user), as: :json
    assert_response :success
  end

  test "should update teacher" do
    patch user_url(@user), params: { user: { email: @user.email, fullname: @user.fullname, password: @user.password, roots: @user.roots } }, as: :json
    assert_response :success
  end

  test "should destroy teacher" do
    assert_difference("Teacher.count", -1) do
      delete user_url(@user), as: :json
    end

    assert_response :no_content
  end
end
