defmodule AssetTracker.Repo do
  use Ecto.Repo,
    otp_app: :asset_tracker,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 5
end
