defmodule AssetTracker.Transactions do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Transactions.{Action, Transaction}

  def list_transactions do
    Repo.all(Transaction) |> Repo.preload(:actions)
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id) |> Repo.preload(:actions)

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.create_changeset(attrs)
    |> Repo.insert()
  end

  @spec create_transaction_update_assets(map()) ::
          {:error, Ecto.Multi.name(), any(), %{required(Ecto.Multi.name()) => any()}}
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

  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end
end
