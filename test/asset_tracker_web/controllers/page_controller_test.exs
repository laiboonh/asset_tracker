defmodule AssetTrackerWeb.PageControllerTest do
  use AssetTrackerWeb.ConnCase, async: true

  import AssetTracker.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /" do
    test "logged in new user shows at least a Brokerages link", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get("/")
      assert html_response(conn, 200) =~ "Brokerages"
    end
  end
end
