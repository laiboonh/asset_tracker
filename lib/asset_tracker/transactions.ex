defmodule AssetTracker.Transactions do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Transactions.{Action, Transaction}

  def list_transactions do
    Repo.all(Transaction)
    |> Repo.preload(actions: [:asset], brokerage: [])
  end

  def list_actions do
    Repo.all(Action)
  end

  def get_transaction!(id),
    do: Repo.get!(Transaction, id) |> Repo.preload(actions: [:asset], brokerage: [])

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.create_changeset(attrs)
    |> Repo.insert()
  end

  @spec create_transaction_update_assets(map()) ::
          {:ok, any()}
          | {:error, Ecto.Multi.name(), any(), %{required(Ecto.Multi.name()) => any()}}
  def create_transaction_update_assets(attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:create_transaction, fn _repo, %{} ->
      create_transaction(attrs)
    end)
    |> Ecto.Multi.run(:update_assets, fn _repo, %{create_transaction: transaction} ->
      results =
        Enum.map(transaction.actions, fn action ->
          %Action{asset: asset, units: units} = action |> Repo.preload(:asset)
          {1, _select_result} = AssetTracker.Assets.update_units(asset.id, units)
        end)

      {:ok, results}
    end)
    |> Repo.transaction()
  end

  @spec delete_transaction(struct()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  defp delete_transaction(%Transaction{} = transaction) do
    transaction
    |> Transaction.changeset(%{})
    |> Repo.delete()
  end

  @spec delete_transaction_and_update_assets(non_neg_integer()) ::
          {:ok, any()}
          | {:error, Ecto.Multi.name(), any(), %{required(Ecto.Multi.name()) => any()}}
  def delete_transaction_and_update_assets(id) do
    transaction = get_transaction!(id)

    Ecto.Multi.new()
    |> Ecto.Multi.run(:update_assets, fn _repo, %{} ->
      results =
        Enum.map(transaction.actions, fn action ->
          %Action{asset: asset, units: units} = action |> Repo.preload(:asset)

          {1, _select_result} =
            AssetTracker.Assets.update_units(asset.id, units |> Decimal.negate())
        end)

      {:ok, results}
    end)
    |> Ecto.Multi.run(:delete_transaction, fn _repo, %{} ->
      delete_transaction(transaction)
    end)
    |> Repo.transaction()
  end

  def change_transaction(%Transaction{} = transaction, params \\ %{}),
    do: Transaction.create_changeset(transaction, params)

  def change_action(%Action{} = action, params \\ %{}),
    do: Action.create_changeset(action, params)
end
