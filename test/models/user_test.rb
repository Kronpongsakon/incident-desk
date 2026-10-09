require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "fixtures have their role" do
    assert_equal "customer", users(:customer).role
    assert_equal "agent", users(:agent).role
  end

  test "create_with_role! creates a user with the given role" do
    user = User.create_with_role!(email_address: "new@example.com", password: "secret123", role: "agent")

    assert user.persisted?
    assert user.has_role?(:agent)
    assert_equal "agent", user.reload.role
  end

  test "is invalid without a role" do
    user = User.new(email_address: "norole@example.com", password: "secret123")

    assert_not user.valid?
    assert_includes user.errors.full_messages.to_sentence, "must have exactly one role"
  end

  test "rejects a role other than customer or agent" do
    assert_raises ActiveRecord::RecordInvalid do
      User.create_with_role!(email_address: "admin@example.com", password: "secret123", role: "admin")
    end
  end

  test "is invalid with both roles" do
    user = User.new(email_address: "both@example.com", password: "secret123")
    user.add_role(:customer)
    user.add_role(:agent)

    assert_not user.valid?
  end
end
