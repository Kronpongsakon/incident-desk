require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "redirects to sign-in when signed out" do
    get root_path

    assert_redirected_to new_session_path
  end

  test "shows the top bar with email, role and log out for a customer" do
    sign_in_as(users(:customer))

    get root_path

    assert_response :success
    assert_select ".topbar" do
      assert_select ".brand", "Incident Desk"
      assert_select ".user span", "customer@example.com · Customer"
      assert_select "form[action=?] button", session_path, text: "Log out"
    end
  end

  test "shows the agent role in the top bar" do
    sign_in_as(users(:agent))

    get root_path

    assert_select ".user span", "agent@example.com · Agent"
  end
end
