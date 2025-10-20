class User < ApplicationRecord
  has_secure_password

  before_save :normalize_fields

  # User validation
  validates :name, presence: true
  validates :lastname, presence: true
  validates :email, format: {
    with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    message: "must be a valid email" },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true }

  private

  def normalize_fields
    self.email = email&.downcase&.strip if email.present?
    self.name = name&.strip&.capitalize if name.present?
    self.lastname = lastname&.strip&.capitalize if lastname.present?
  end
end
