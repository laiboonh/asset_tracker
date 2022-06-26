defmodule AssetTracker.Assets do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Assets.Asset

  @spec list_assets(Ecto.UUID.t()) :: [Asset.t()]
  def list_assets(user_id) do
    from(Asset) |> where([a], a.user_id == ^user_id) |> preload(:brokerage) |> Repo.all()
  end

  @spec list_assets_by_brokerage(Ecto.UUID.t(), Ecto.UUID.t()) :: [Asset.t()]
  def list_assets_by_brokerage(brokerage_id, user_id) do
    from(Asset)
    |> where([a], a.brokerage_id == ^brokerage_id and a.user_id == ^user_id)
    |> preload(:brokerage)
    |> Repo.all()
  end

  def get_asset!(id), do: Repo.get!(Asset, id) |> Repo.preload(:brokerage)

  def get_asset(id), do: Repo.get(Asset, id) |> Repo.preload(:brokerage)

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

  @spec delete_asset(AssetTracker.Assets.Asset.t()) ::
          {:ok, Asset.t()} | {:error, Ecto.Changeset.t()}
  def delete_asset(%Asset{} = asset) do
    asset
    |> Asset.changeset(%{})
    |> Repo.delete()
  end

  def change_asset(%Asset{} = asset, params \\ %{}),
    do: Asset.changeset(asset, params)
end
