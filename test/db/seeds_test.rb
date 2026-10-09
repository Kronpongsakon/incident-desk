require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  setup { User.destroy_all }

  test "creates one customer and one agent with the password from SEED_PASSWORD" do
    ENV["SEED_PASSWORD"] = "seeded-secret"
    load Rails.root.join("db/seeds.rb")
    load Rails.root.join("db/seeds.rb")

    assert_equal 2, User.count
    assert_equal "customer", User.find_by!(email_address: "customer@example.com").role
    assert_equal "agent", User.find_by!(email_address: "agent@example.com").role
    assert User.find_by!(email_address: "agent@example.com").authenticate("seeded-secret")
  ensure
    ENV.delete("SEED_PASSWORD")
  end

  test "aborts without SEED_PASSWORD" do
    ENV.delete("SEED_PASSWORD")

    assert_raises(SystemExit) do
      assert_output(nil, /Set SEED_PASSWORD/) { load Rails.root.join("db/seeds.rb") }
    end
    assert_equal 0, User.count
  end
end
