defmodule AssetTrackerWeb.Utils do
  @moduledoc false
  def get_user_id(%{"user_token" => user_token}) do
    user = AssetTracker.Accounts.get_user_by_session_token(user_token)
    user.id
  end

  @spec error_message(Ecto.Changeset.t()) :: binary
  def error_message(changeset) do
    errors = changeset.errors

    Enum.map_join(Keyword.keys(errors), "\n", fn key ->
      {message, _} = Keyword.get(errors, key)
      "#{key} #{message}"
    end)
  end
end
