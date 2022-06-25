defmodule AssetTracker.Brokerages do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Brokerages.Brokerage

  def list_brokerages(user_id) do
    from(Brokerage) |> where([b], b.user_id == ^user_id) |> Repo.all()
  end

  def get_brokerage!(id), do: Repo.get!(Brokerage, id)

  def create_brokerage(attrs \\ %{}) do
    %Brokerage{}
    |> Brokerage.changeset(attrs)
    |> Repo.insert()
  end

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
