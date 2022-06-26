defmodule AssetTracker.Brokerages do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Brokerages.Brokerage

  @spec list_brokerages(non_neg_integer()) :: [Brokerage.t()]
  def list_brokerages(user_id) do
    from(Brokerage) |> where([b], b.user_id == ^user_id) |> Repo.all()
  end

  @spec get_brokerage(non_neg_integer(), non_neg_integer()) ::
          {:ok, Brokerage.t()} | {:error, :not_found | :unauthorized}
  def get_brokerage(id, user_id) do
    case Repo.get(Brokerage, id) do
      nil ->
        {:error, :not_found}

      brokerage ->
        if brokerage.user_id == user_id, do: {:ok, brokerage}, else: {:error, :unauthorized}
    end
  end

  def create_brokerage(attrs \\ %{}) do
    %Brokerage{}
    |> Brokerage.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_brokerage(Brokerage.t(), map()) ::
          {:ok, Brokerage.t()} | {:error, Ecto.Changeset.t()}
  def update_brokerage(%Brokerage{} = brokerage, attrs) do
    brokerage
    |> Brokerage.changeset(attrs)
    |> Repo.update()
  end

  def delete_brokerage(%Brokerage{} = brokerage) do
    brokerage
    |> Brokerage.changeset(%{})
    |> Repo.delete()
  end

  def change_brokerage(%Brokerage{} = brokerage, params \\ %{}),
    do: Brokerage.changeset(brokerage, params)
end
