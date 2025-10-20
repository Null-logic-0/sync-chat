class UsersController < ApplicationController
  before_action :set_user, only: [ :show ]
  before_action :require_login, except: [ :new, :create ]
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def show; end

  def profile
    @user = current_user
    render :show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_session_for(@user)
      redirect_to profile_path, notice: "Thank you for signing up!"
    else
      flash.now[:alert] = @user.errors.full_messages
      render "new", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :lastname, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
