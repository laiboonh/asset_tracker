defmodule AssetTracker.Transactions.Action do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "actions" do
    belongs_to :transaction, AssetTracker.Transactions.Transaction
    belongs_to :asset, AssetTracker.Assets.Asset
    field :units, :float
    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:transaction_id, :asset_id, :units])
    |> validate_required([:transaction_id, :asset_id, :units])
  end

  def create_changeset(action, attrs) do
    action
    |> cast(attrs, [:transaction_id, :asset_id, :units])
    |> validate_required([:asset_id, :units])
  end
end
