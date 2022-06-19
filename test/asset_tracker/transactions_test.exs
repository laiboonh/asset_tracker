defmodule AssetTracker.TransactionsTest do
  use AssetTracker.DataCase

  alias AssetTracker.Transactions
  alias AssetTracker.Transactions.Transaction

  import AssetTracker.AssetsFixtures
  import AssetTracker.TransactionsFixtures

  describe "transactions" do
    @invalid_attrs %{transacted_at: nil}

    test "list_transactions/0 returns all transaction" do
      transaction = transaction_fixture() |> Repo.preload(actions: [:asset], brokerage: [])
      assert Transactions.list_transactions() == [transaction]
    end

    test "list_actions/0 returns all action" do
      transaction = transaction_fixture()
      assert Transactions.list_actions() == transaction.actions
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture() |> Repo.preload(actions: [:asset], brokerage: [])
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

      valid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        actions: [
          %{
            asset_id: asset.id,
            units: 0.0
          }
        ]
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert length(transaction.actions) == 1
    end

    test "create_transaction_update_assets/1 with valid data creates a transaction" do
      asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

      valid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        actions: [
          %{
            asset_id: asset.id,
            units: -5.0
          }
        ]
      }

      assert {:ok, results} = Transactions.create_transaction_update_assets(valid_attrs)

      %Transaction{} = transaction = results.create_transaction

      assert length(transaction.actions) == 1

      asset = AssetTracker.Assets.get_asset!(asset.id)

      assert asset.units == 5.0
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "delete_transaction_and_update_assets/1 with valid data deletes transaction and revert updates done to assets" do
      asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

      valid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        actions: [
          %{
            asset_id: asset.id,
            units: 5.0
          }
        ]
      }

      assert {:ok, results} = Transactions.create_transaction_update_assets(valid_attrs)

      %Transaction{} = transaction = results.create_transaction

      assert length(transaction.actions) == 1

      asset = AssetTracker.Assets.get_asset!(asset.id)

      assert asset.units == 15.0

      assert {:ok, _results} = Transactions.delete_transaction_and_update_assets(transaction.id)

      asset = AssetTracker.Assets.get_asset!(asset.id)

      assert asset.units == 10.0

      assert_raise Ecto.NoResultsError, fn ->
        AssetTracker.Transactions.get_transaction!(transaction.id)
      end
    end
  end
end
