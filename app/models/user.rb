class User < ApplicationRecord
  ROLES = %w[ customer agent ].freeze

  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validate :has_exactly_one_known_role

  def role
    roles.first&.name
  end

  def customer?
    has_role? :customer
  end

  def agent?
    has_role? :agent
  end

  private
    def has_exactly_one_known_role
      names = roles.map(&:name)
      errors.add(:roles, "must be either customer or agent") unless names.one? && ROLES.include?(names.first)
    end
end
