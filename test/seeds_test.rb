require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  setup { User.destroy_all }

  test "creates one customer and one agent with the password from SEED_PASSWORD" do
    with_seed_password("seed-secret") { load_seeds }

    assert_equal "customer", User.authenticate_by(email_address: "customer@example.com", password: "seed-secret").role
    assert_equal "agent", User.authenticate_by(email_address: "agent@example.com", password: "seed-secret").role
    assert_equal 2, User.count
  end

  test "running twice creates no duplicates" do
    with_seed_password("seed-secret") { 2.times { load_seeds } }

    assert_equal 2, User.count
  end

  test "creates no users without SEED_PASSWORD" do
    with_seed_password(nil) { load_seeds }

    assert_equal 0, User.count
  end

  private
    def load_seeds
      capture_io { load Rails.root.join("db/seeds.rb") }
    end

    def with_seed_password(value)
      previous, ENV["SEED_PASSWORD"] = ENV["SEED_PASSWORD"], value
      yield
    ensure
      ENV["SEED_PASSWORD"] = previous
    end
end
