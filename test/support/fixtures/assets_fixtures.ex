defmodule AssetTracker.AssetsFixtures do
  @moduledoc false

  import AssetTracker.BrokeragesFixtures

  def asset_fixture(attrs \\ %{}) do
    brokerage =
      (Map.get(attrs, :brokerage) || brokerage_fixture()) |> AssetTracker.Repo.preload(:user)

    {:ok, asset} =
      attrs
      |> Enum.into(%{
        user_id: brokerage.user.id,
        brokerage_id: brokerage.id,
        name: Map.get(attrs, :name) || "some name",
        units: (Map.get(attrs, :units) || 10.0) |> Decimal.from_float()
      })
      |> AssetTracker.Assets.create_asset()

    asset |> AssetTracker.Repo.preload(:brokerage)
  end
end
