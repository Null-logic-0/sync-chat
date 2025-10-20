require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @password = "password1234"
  end

  # --GET /signup
  test "should get new (signup) page" do
    get signup_path
    assert_response :success
    assert_select "form"
  end

  # --POST /users
  test "should create new user" do
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          name: "john",
          lastname: "doe",
          email: "new@example.com",
          password: "password1234",
          password_confirmation: "password1234"
        }
      }
    end
    assert_redirected_to profile_path
    follow_redirect!
    assert_match "Thank you for signing up!", response.body
  end

  test "should not create new user" do
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          email: "",
          password: "123",
          password_confirmation: "456"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  # --- GET /profile ---
  test "should show current_user profile" do
    log_in_as(@user)
    get profile_path
    assert_response :success
    assert_select "h1", text: @user.name
  end

  test "should redirect profile when not logged in" do
    get profile_path
    assert_redirected_to login_path
  end
end
