require "test_helper"
require "rake"

class UsersRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("users:create")
    Rake::Task["users:create"].reenable
  end

  test "creates a user with the role and the password from PASSWORD" do
    with_env("PASSWORD" => "secret123") do
      assert_output(/Created agent new-agent@example.com/) do
        Rake::Task["users:create"].invoke("new-agent@example.com", "agent")
      end
    end

    user = User.find_by!(email_address: "new-agent@example.com")
    assert_equal "agent", user.role
    assert user.authenticate("secret123")
  end

  test "rejects an unknown role" do
    with_env("PASSWORD" => "secret123") do
      assert_raises(SystemExit) do
        assert_output(nil, /Role must be one of/) { Rake::Task["users:create"].invoke("x@example.com", "admin") }
      end
    end

    assert_not User.exists?(email_address: "x@example.com")
  end

  private
    def with_env(vars)
      previous = vars.keys.index_with { |key| ENV[key] }
      vars.each { |key, value| ENV[key] = value }
      yield
    ensure
      previous.each { |key, value| ENV[key] = value }
    end
end
