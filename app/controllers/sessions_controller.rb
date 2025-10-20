class SessionsController < ApplicationController
  before_action :require_login, except: [ :new, :create ]
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def new; end

  def create
    user_params = params.require(:user).permit(:email, :password)
    user = User.find_by(email: user_params[:email])

    if user&.authenticate(user_params[:password])
      create_session_for(user)
      redirect_to profile_path, notice: "Welcome back, #{user&.name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render "new", status: :unauthorized
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have been logged out"
    redirect_to login_url
  rescue => e
    redirect_to profile_url, alert: "Something went wrong"
  end
end
