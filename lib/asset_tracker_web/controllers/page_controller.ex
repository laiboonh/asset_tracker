defmodule AssetTrackerWeb.PageController do
  use AssetTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
