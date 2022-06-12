defmodule AssetTracker.TransactionsTest do
  use AssetTracker.DataCase

  alias AssetTracker.Transactions
  alias AssetTracker.Transactions.Transaction

  import AssetTracker.AssetsFixtures
  import AssetTracker.TransactionsFixtures

  describe "transactions" do
    @invalid_attrs %{transacted_at: nil}

    test "list_transactions/0 returns all transaction" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
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

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      today = Date.utc_today()
      update_attrs = %{transacted_at: today}

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, update_attrs)

      assert transaction.transacted_at == today
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.id)
    end
  end
end
