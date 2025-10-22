class ChatMessagesController < ApplicationController
  before_action :require_login

  def index
    @chat_messages = ChatMessage.includes(:user).order(created_at: :asc)
  end

  def create
    @chat = Chat.find(params[:chat_id])
    @chat_message = @chat.chat_messages.build(chat_message_params.merge(user: current_user))

    if @chat_message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path }
      end
    else
      flash[:alert] = "Message can't be blank"
      redirect_to root_path
    end
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:content)
  end
end
