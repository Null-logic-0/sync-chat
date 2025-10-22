class UsersController < ApplicationController
  before_action :set_user, only: [ :show ]
  before_action :require_login, except: [ :new, :create ]
  before_action :redirect_if_logged_in, only: [ :new, :create ]

  def index
    @chats = Chat.where(sender: current_user)
                 .or(Chat.where(recipient: current_user))
                 .includes(:chat_messages)

    @chats_by_user = @chats.index_by do |chat|
      chat.sender == current_user ? chat.recipient_id : chat.sender_id
    end

    @users = if params[:query].present?
               User.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
    else
               User.where.not(id: current_user&.id).order(created_at: :desc)
    end

    if params[:recipient_id]
      recipient = User.find(params[:recipient_id])
      @selected_chat = Chat.find_by(sender: current_user, recipient: recipient) ||
                       Chat.find_by(sender: recipient, recipient: current_user)
      @selected_chat ||= Chat.create(sender: current_user, recipient: recipient)

      @chat_messages = @selected_chat.chat_messages.includes(:user).order(created_at: :asc)
      @chat_message = ChatMessage.new
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

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
      redirect_to root_path, notice: "Thank you for signing up!"
    else
      flash.now[:alert] = @user.errors.full_messages
      render "new", status: :unprocessable_entity
    end
  end

  def update_profile
    @user = current_user
    if @user.update(profile_params.except(:current_password, :password, :password_confirmation))
      redirect_to profile_path, notice: "Your profile has been updated."
    else
      flash.now[:alert] = @user.errors.full_messages
      render "show", status: :unprocessable_entity
    end
  end

  def settings
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user&.authenticate(password_params[:current_password])
      if @user.update(password_params.slice(:password, :password_confirmation))
        reset_session
        redirect_to login_path, notice: "Your password has been reset."
      else
        flash.now[:alert] = "Failed to update password."
        render "settings", status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Current password is incorrect."
      render "settings", status: :unprocessable_entity
    end
  end

  def delete_account
    @user = current_user
    if @user.destroy
      reset_session
      redirect_to signup_url, alert: "Your account has been deleted."
    else
      flash.now[:alert] = "Failed to delete account."
      render "settings", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :lastname, :email, :password)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:profile_image, :name, :about)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
