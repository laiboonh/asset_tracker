defmodule AssetTracker.Assets do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Assets.Asset

  def list_assets do
    Repo.all(Asset)
  end

  def get_asset!(id), do: Repo.get!(Asset, id)

  def get_asset(id), do: Repo.get(Asset, id)

  def create_asset(attrs \\ %{}) do
    %Asset{}
    |> Asset.changeset(attrs)
    |> Repo.insert()
  end

  def update_asset(%Asset{} = asset, attrs) do
    asset
    |> Asset.changeset(attrs)
    |> Repo.update()
  end

  @spec update_units(non_neg_integer(), float()) :: {non_neg_integer(), nil | [term()]}
  def update_units(id, units) do
    Asset
    |> update([a], inc: [units: ^units])
    |> where([a], a.id == ^id)
    |> select([a], a.units)
    |> Repo.update_all([])
  end
end
