defmodule AssetTracker.AssetsFixtures do
  @moduledoc false

  import AssetTracker.BrokeragesFixtures

  def asset_fixture(attrs \\ %{}) do
    brokerage = brokerage_fixture() |> AssetTracker.Repo.preload(:user)

    {:ok, asset} =
      attrs
      |> Enum.into(%{
        user_id: brokerage.user.id,
        brokerage_id: brokerage.id,
        name: "some name",
        units: 10.0
      })
      |> AssetTracker.Assets.create_asset()

    asset
  end
end
