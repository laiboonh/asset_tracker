defmodule AssetTracker.Brokerages do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Brokerages.Brokerage

  def list_brokerage do
    Repo.all(Brokerage)
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
end
