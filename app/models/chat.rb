class Chat < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  has_many :chat_messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }

  def last_message
    chat_messages.order(created_at: :desc).first
  end
end
