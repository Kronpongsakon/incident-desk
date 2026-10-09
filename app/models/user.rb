class User < ApplicationRecord
  ROLES = %w[ customer agent ].freeze

  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validate :must_have_exactly_one_role

  def self.create_with_role!(email_address:, password:, role:)
    new(email_address: email_address, password: password).tap do |user|
      user.add_role(role) if ROLES.include?(role.to_s)
      user.save!
    end
  end

  def role
    roles.first&.name
  end

  private
    def must_have_exactly_one_role
      unless roles.size == 1 && ROLES.include?(role)
        errors.add(:base, "must have exactly one role: #{ROLES.to_sentence(two_words_connector: " or ", last_word_connector: ", or ")}")
      end
    end
end
