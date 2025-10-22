class AddChatRefToChatMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :chat_messages, :chat, null: false, foreign_key: true
  end
end
