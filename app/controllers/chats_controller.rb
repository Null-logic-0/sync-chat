class ChatsController < ApplicationController
  before_action :require_login

  def start
    recipient = User.find(params[:recipient_id])

    @selected_chat = Chat.find_by(sender: current_user, recipient: recipient) ||
                     Chat.find_by(sender: recipient, recipient: current_user)
    @selected_chat ||= Chat.create(sender: current_user, recipient: recipient)

    @chat_messages = @selected_chat.chat_messages.includes(:user).order(created_at: :asc)
    @chat_message = ChatMessage.new

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "chat_frame",
          partial: "users/chat_frame",
          locals: { selected_chat: @selected_chat, chat_messages: @chat_messages, chat_message: @chat_message }
        )
      end

      format.html { redirect_to root_path, notice: "Chat started." }
    end
  end
end
