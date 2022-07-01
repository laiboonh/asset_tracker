defmodule AssetTrackerWeb.PageController do
  use AssetTrackerWeb, :controller

  alias AssetTracker.{Brokerages, Assets}

  def index(conn, _params) do
    conn =
      if get_session(conn, :user_token) != nil do
        user = AssetTracker.Accounts.get_user_by_session_token(get_session(conn, :user_token))

        conn
        |> assign(:brokerages, Brokerages.list_brokerages(user.id))
        |> assign(:assets, Assets.list_assets(user.id))
      else
        conn
      end

    conn
    |> render("index.html")
  end
end
