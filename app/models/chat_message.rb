class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat
  after_create_commit do
    chat_users = [ chat.sender, chat.recipient ]
    chat_users.each do |u|
      broadcast_append_to [ chat, u ],
                          target: "chat_messages",
                          partial: "chats/message",
                          locals: { chat_message: self, current_user: u }
    end
  end
end
