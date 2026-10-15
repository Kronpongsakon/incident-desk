require "test_helper"
require "rake"

class UsersRakeTest < ActiveSupport::TestCase
  setup do
    unless Rake::Task.task_defined?("users:create")
      # The test process has already booted Rails, so :environment has nothing left to do.
      Rake::Task.define_task(:environment)
      load Rails.root.join("lib/tasks/users.rake")
    end
  end

  test "creates a user with the given role and the password from PASSWORD" do
    with_env("PASSWORD" => "rake-secret") do
      assert_output(/Created agent new\.agent@example\.com/) { create_user "new.agent@example.com", "agent" }
    end

    user = User.authenticate_by(email_address: "new.agent@example.com", password: "rake-secret")
    assert_equal "agent", user.role
  end

  test "reads the password from standard input when PASSWORD is not set" do
    with_env("PASSWORD" => nil) do
      with_stdin("prompted-secret\n") do
        capture_io { create_user "new.customer@example.com", "customer" }
      end
    end

    user = User.authenticate_by(email_address: "new.customer@example.com", password: "prompted-secret")
    assert_equal "customer", user.role
  end

  test "refuses a role other than customer or agent" do
    with_env("PASSWORD" => "rake-secret") do
      assert_aborts(/Role must be one of: customer, agent/) { create_user "new@example.com", "admin" }
    end

    assert_not User.exists?(email_address: "new@example.com")
  end

  test "refuses a blank password" do
    with_env("PASSWORD" => nil) do
      with_stdin("\n") do
        assert_aborts(/Password must not be blank/) { create_user "new@example.com", "customer" }
      end
    end

    assert_not User.exists?(email_address: "new@example.com")
  end

  test "refuses an email that is already taken" do
    with_env("PASSWORD" => "rake-secret") do
      assert_aborts(/Email address has already been taken/) { create_user users(:customer).email_address, "customer" }
    end
  end

  private
    def create_user(email_address, role)
      Rake::Task["users:create"].reenable
      Rake::Task["users:create"].invoke(email_address, role)
    end

    def assert_aborts(message, &block)
      _out, err = capture_io { assert_raises(SystemExit, &block) }
      assert_match message, err
    end

    def with_env(values)
      previous = values.keys.index_with { |key| ENV[key] }
      values.each { |key, value| ENV[key] = value }
      yield
    ensure
      previous.each { |key, value| ENV[key] = value }
    end

    def with_stdin(input)
      previous, $stdin = $stdin, StringIO.new(input)
      yield
    ensure
      $stdin = previous
    end
end
