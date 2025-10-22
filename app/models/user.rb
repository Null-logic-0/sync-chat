class User < ApplicationRecord
  has_secure_password

  before_save :normalize_fields

  has_one_attached :profile_image, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

  # User validation
  validates :name, presence: true
  validates :lastname, presence: true
  validates :email, format: {
    with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    message: "must be a valid email" },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true }
  validate :acceptable_image

  def touch_last_seen!
    update_column(:last_seen_at, Time.current)
  end

  def online?
    last_seen_at && last_seen_at > 5.minutes.ago
  end

  private

  def acceptable_image
    return unless profile_image.attached?

    unless profile_image.byte_size <= 8.megabyte
      errors.add(:profile_image, "must be less than 8MB")
    end

    acceptable_types = %w[image/png image/jpg image/jpeg]
    unless acceptable_types.include? profile_image.content_type
      errors.add(:profile_image, "must be a png, jpg, or jpeg format!")
    end
  end

  def normalize_fields
    self.email = email&.downcase&.strip if email.present?
    self.name = name&.strip&.capitalize if name.present?
    self.lastname = lastname&.strip&.capitalize if lastname.present?
  end
end
