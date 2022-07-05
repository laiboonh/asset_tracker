defmodule AssetTracker.TransactionsTest do
  use AssetTracker.DataCase

  alias AssetTracker.Transactions
  alias AssetTracker.Transactions.Transaction

  import AssetTracker.AssetsFixtures
  import AssetTracker.TransactionsFixtures

  describe "transactions" do
    test "list_transactions/1 returns all transaction" do
      transaction = transaction_fixture() |> Repo.preload(actions: [:asset], brokerage: [])
      assert Transactions.list_transactions(transaction.user_id) == [transaction]
    end

    test "get_transaction/2 returns the transaction with given id" do
      transaction = transaction_fixture() |> Repo.preload(actions: [:asset], brokerage: [])

      assert Transactions.get_transaction(transaction.id, transaction.user_id) ==
               {:ok, transaction}
    end

    test "create_transaction_update_assets/1 with valid data creates a transaction" do
      asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

      valid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        type: :deposit,
        actions: [
          %{
            asset_id: asset.id,
            units: -5.0,
            type: :transfer_in
          }
        ]
      }

      assert {:ok, results} = Transactions.create_transaction_update_assets(valid_attrs)

      %Transaction{} = transaction = results.create_transaction

      assert length(transaction.actions) == 1

      {:ok, asset} = AssetTracker.Assets.get_asset(asset.id, asset.user_id)

      assert asset.units == Decimal.from_float(5.0)
    end

    test "create_transaction_update_assets/1 with invalid data returns error changeset" do
      asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

      invalid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: nil,
        type: :deposit,
        actions: [
          %{
            asset_id: asset.id,
            units: -5.0,
            type: :transfer_in
          }
        ]
      }

      {:error, :create_transaction, %Ecto.Changeset{errors: errors}, _changes_so_far} =
        Transactions.create_transaction_update_assets(invalid_attrs)

      assert errors |> Keyword.keys() |> Enum.member?(:transacted_at)
    end

    test "delete_transaction_and_update_assets/2 with valid data deletes transaction and revert updates done to assets" do
      asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

      valid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        type: :deposit,
        actions: [
          %{
            asset_id: asset.id,
            units: 5.0,
            type: :transfer_in
          }
        ]
      }

      assert {:ok, results} = Transactions.create_transaction_update_assets(valid_attrs)

      %Transaction{} = transaction = results.create_transaction

      assert length(transaction.actions) == 1

      {:ok, asset} = AssetTracker.Assets.get_asset(asset.id, asset.user_id)

      assert asset.units == Decimal.from_float(15.0)

      assert {:ok, _results} =
               Transactions.delete_transaction_and_update_assets(transaction.id, asset.user_id)

      {:ok, asset} = AssetTracker.Assets.get_asset(asset.id, asset.user_id)

      assert asset.units == Decimal.from_float(10.0)

      assert AssetTracker.Transactions.get_transaction(transaction.id, asset.user_id) ==
               {:error, :not_found}
    end
  end
end
