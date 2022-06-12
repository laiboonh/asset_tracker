defmodule AssetTracker.Transactions do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Transactions.Transaction

  def list_transactions do
    Repo.all(Transaction) |> Repo.preload(:actions)
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id) |> Repo.preload(:actions)

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end
end
