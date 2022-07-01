defmodule AssetTrackerWeb.PageController do
  use AssetTrackerWeb, :controller

  alias AssetTracker.{Assets, Brokerages}

  def index(conn, _params) do
    conn =
      with user_token when is_nil(user_token) != true <- get_session(conn, :user_token),
           user when is_nil(user) != true <-
             AssetTracker.Accounts.get_user_by_session_token(get_session(conn, :user_token)) do
        conn
        |> assign(:brokerages, Brokerages.list_brokerages(user.id))
        |> assign(:assets, Assets.list_assets(user.id))
      else
        nil -> conn
      end

    conn
    |> render("index.html")
  end
end
