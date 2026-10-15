require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "a customer is valid" do
    user = build_user
    user.add_role :customer

    assert user.valid?
    assert user.customer?
  end

  test "an agent is valid" do
    user = build_user
    user.add_role :agent

    assert user.valid?
    assert user.agent?
  end

  test "a user without a role is invalid" do
    user = build_user

    assert_not user.valid?
    assert_includes user.errors[:roles], "must be either customer or agent"
  end

  test "a user with a role other than customer or agent is invalid" do
    user = build_user
    user.add_role :admin

    assert_not user.valid?
    assert_includes user.errors[:roles], "must be either customer or agent"
  end

  test "a user with both roles is invalid" do
    user = build_user
    user.add_role :customer
    user.add_role :agent

    assert_not user.valid?
    assert_includes user.errors[:roles], "must be either customer or agent"
  end

  test "role names the user's role" do
    assert_equal "customer", users(:customer).role
    assert_equal "agent", users(:agent).role
  end

  private
    def build_user
      User.new(email_address: "new@example.com", password: "secret-password")
    end
end
