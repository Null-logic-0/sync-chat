require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @password = "password1234"
  end

  # GET /login
  test "should get login page" do
    get login_path
    assert_response :success
  end

  # POST /sessions - successful login
  test "should log in with valid credentials" do
    post sessions_path, params: { user: { email: @user.email, password: @password } }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_equal @user.id, session[:user_id]
  end

  # DELETE /session - logout
  test "should log out user" do
    log_in_as(@user)
    assert_equal @user.id, session[:user_id]
    delete logout_path
    assert_redirected_to login_url
    follow_redirect!
    assert_nil session[:user_id]
    assert_response :success
  end
end
