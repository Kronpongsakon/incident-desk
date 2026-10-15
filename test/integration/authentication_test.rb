require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "visiting the dashboard while signed out redirects to sign-in" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "a customer signs in with valid credentials and lands on the dashboard" do
    sign_in_with users(:customer).email_address, "password"

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "an agent signs in with valid credentials and lands on the dashboard" do
    sign_in_with users(:agent).email_address, "password"

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "the sign-in form takes an email and a password" do
    get new_session_path

    assert_response :success
    assert_select "form.auth-card[action=?]", session_path do
      assert_select "input[type=email][name=email_address]"
      assert_select "input[type=password][name=password]"
      assert_select "button[type=submit]", "Sign in"
    end
    assert_select ".alert-error", count: 0
  end

  test "invalid credentials keep the visitor on sign-in with an error" do
    sign_in_with users(:customer).email_address, "wrong-password"

    assert_response :unprocessable_entity
    assert_select ".alert-error", "Invalid email or password"
    assert_select "input[name=email_address][value=?]", users(:customer).email_address
    assert_nil cookies[:session_id]
  end

  test "an unknown email shows the same error" do
    sign_in_with "nobody@example.com", "password"

    assert_response :unprocessable_entity
    assert_select ".alert-error", "Invalid email or password"
  end

  test "a signed-in customer sees their email, role and a log out button in the top bar" do
    sign_in_as users(:customer)

    get root_path

    assert_select "header.topbar" do
      assert_select ".brand", "Incident Desk"
      assert_select ".user", /customer@example\.com · Customer/
      assert_select "form[action=?] button", session_path, "Log out"
    end
  end

  test "a signed-in agent sees their email and role in the top bar" do
    sign_in_as users(:agent)

    get root_path

    assert_select "header.topbar .user", /agent@example\.com · Agent/
  end

  test "the sign-in page has no top bar" do
    get new_session_path

    assert_select "header.topbar", count: 0
  end

  test "logging out ends a customer's session and the dashboard is unreachable afterwards" do
    assert_log_out_ends_session_for users(:customer)
  end

  test "logging out ends an agent's session and the dashboard is unreachable afterwards" do
    assert_log_out_ends_session_for users(:agent)
  end

  test "logging out from a stale tab and signing in again lands on the dashboard" do
    sign_in_with users(:customer).email_address, "password"
    users(:customer).sessions.destroy_all

    delete session_path
    assert_redirected_to new_session_path

    sign_in_with users(:customer).email_address, "password"
    assert_redirected_to root_url
  end

  test "signing in without a password shows the invalid credentials error" do
    post session_path, params: { email_address: users(:customer).email_address }

    assert_response :unprocessable_entity
    assert_select ".alert-error", "Invalid email or password"
  end

  private
    def assert_log_out_ends_session_for(user)
      sign_in_with user.email_address, "password"

      delete session_path

      assert_redirected_to new_session_path
      get root_path
      assert_redirected_to new_session_path
    end

    def sign_in_with(email_address, password)
      post session_path, params: { email_address: email_address, password: password }
    end
end
