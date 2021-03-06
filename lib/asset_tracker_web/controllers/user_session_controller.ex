defmodule AssetTrackerWeb.UserSessionController do
  use AssetTrackerWeb, :controller

  alias AssetTracker.Accounts
  alias AssetTrackerWeb.UserAuth

  def new(conn, _params) do
    oauth_google_url = ElixirAuthGoogle.generate_oauth_url(conn)
    render(conn, "new.html", error_message: nil, oauth_google_url: oauth_google_url)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      oauth_google_url = ElixirAuthGoogle.generate_oauth_url(conn)

      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html",
        error_message: "Invalid email or password",
        oauth_google_url: oauth_google_url
      )
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
