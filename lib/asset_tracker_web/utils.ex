defmodule AssetTrackerWeb.Utils do
  @moduledoc false
  def get_user_id(%{"user_token" => user_token}) do
    user = AssetTracker.Accounts.get_user_by_session_token(user_token)
    user.id
  end
end
