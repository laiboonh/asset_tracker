defmodule AssetTrackerWeb.GoogleAuthController do
  use AssetTrackerWeb, :controller

  alias AssetTracker.Accounts
  alias AssetTrackerWeb.UserAuth

  @doc """
  `index/2` handles the callback from Google Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)

    case Accounts.upsert_user(%{email: profile.email}) do
      {:ok, user} ->
        conn
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "User record was not created successfully. #{inspect(changeset)}")
        |> redirect(to: Routes.user_session_path(conn, :new))
    end
  end
end
