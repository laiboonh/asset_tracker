defmodule AssetTracker.PortfoliosFixtures do
  @moduledoc false

  import AssetTracker.AssetsFixtures

  def portfolio_fixture(attrs \\ %{}) do
    asset = asset_fixture() |> AssetTracker.Repo.preload(:user)

    {:ok, portfolio} =
      attrs
      |> Enum.into(%{
        user_id: asset.user_id,
        name: "portfolio#{System.unique_integer()}",
        assets: [asset]
      })
      |> AssetTracker.Portfolios.create_portfolio()

    portfolio
  end
end
