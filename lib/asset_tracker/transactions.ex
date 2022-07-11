defmodule AssetTracker.Transactions do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Transactions.{Action, Transaction}

  @spec list_transactions(Ecto.UUID.t()) :: Scrivener.Page.t()
  def list_transactions(user_id, options \\ %{}) do
    from(Transaction)
    |> where([t], t.user_id == ^user_id)
    |> order_by([t], desc: t.transacted_at)
    |> preload(actions: [:asset])
    |> Repo.paginate(options)
  end

  @spec get_transaction(Ecto.UUID.t(), Ecto.UUID.t()) ::
          {:ok, Transaction.t()} | {:error, :not_found | :unauthorized}
  def get_transaction(id, user_id) do
    case Repo.get(Transaction, id) |> Repo.preload(actions: [:asset]) do
      nil ->
        {:error, :not_found}

      transaction ->
        if transaction.user_id == user_id, do: {:ok, transaction}, else: {:error, :unauthorized}
    end
  end

  defp create_transaction(attrs) do
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

  @spec delete_transaction_and_update_assets(Ecto.UUID.t(), Ecto.UUID.t()) ::
          {:ok, any()}
          | {:error, Ecto.Multi.name(), any(), %{required(Ecto.Multi.name()) => any()}}
          | {:error, :not_found | :unauthorized}
  def delete_transaction_and_update_assets(id, user_id) do
    case get_transaction(id, user_id) do
      {:ok, transaction} ->
        do_delete_transaction_and_update_assets(transaction)

      others ->
        others
    end
  end

  defp do_delete_transaction_and_update_assets(transaction) do
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

  @spec delete_transaction(struct()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  defp delete_transaction(%Transaction{} = transaction) do
    transaction
    |> Transaction.changeset(%{})
    |> Repo.delete()
  end

  def change_transaction(%Transaction{} = transaction, params \\ %{}),
    do: Transaction.create_changeset(transaction, params)

  def change_action(%Action{} = action, params \\ %{}),
    do: Action.create_changeset(action, params)
end
