defmodule AssetTracker.TransactionsFixtures do
  @moduledoc false

  import AssetTracker.AssetsFixtures

  def transaction_fixture(attrs \\ %{}) do
    asset =
      (Map.get(attrs, :asset) || asset_fixture())
      |> AssetTracker.Repo.preload([:user])

    {:ok, results} =
      attrs
      |> Enum.into(%{
        user_id: asset.user_id,
        transacted_at: Map.get(attrs, :transacted_at) || Date.utc_today(),
        type: :deposit,
        actions: [
          %{
            asset_id: asset.id,
            type: :transfer_in,
            units: 0.0
          }
        ]
      })
      |> AssetTracker.Transactions.create_transaction_update_assets()

    %AssetTracker.Transactions.Transaction{} = results.create_transaction
  end
end
