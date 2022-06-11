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
end
