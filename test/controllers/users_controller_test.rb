require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    log_in_as(@user)
    get root_path
    assert_response :success
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
          name: "John",
          lastname: "Doe",
          email: "new@example.com",
          password: "password1234",
          password_confirmation: "password1234"
        }
      }
    end
    assert_redirected_to root_path
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
    assert_select "h1", text: "Profile"
  end

  test "should redirect profile when not logged in" do
    get profile_path
    assert_redirected_to login_path
  end

  # --- PATCH /profile ---
  test "should update user profile" do
    log_in_as(@user)
    patch profile_path, params: { user: {
      name: "updated name"
    } }
    assert_redirected_to profile_path
    @user.reload
    assert_equal "Updated name", @user.name
  end

  # --- GET /settings ---
  test "should get settings page" do
    log_in_as(@user)
    get settings_path
    assert_response :success
  end

  # --- PATCH /settings ---
  test "should update user password" do
    log_in_as(@user)
    patch update_password_path, params: { user: {
      current_password: "password1234",
      password: "password12345",
      password_confirmation: "password12345"
    } }
    assert_redirected_to login_path
    assert_match /Your password has been reset./i, flash[:notice]
  end
end
