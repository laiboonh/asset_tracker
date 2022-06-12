defmodule AssetTracker.TransactionsFixtures do
  @moduledoc false

  import AssetTracker.AssetsFixtures

  def transaction_fixture(attrs \\ %{}) do
    asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        actions: [
          %{
            asset_id: asset.id,
            units: 0.0
          }
        ]
      })
      |> AssetTracker.Transactions.create_transaction()

    transaction
  end
end