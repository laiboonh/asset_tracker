defmodule AssetTracker.Transactions.Action do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "actions" do
    belongs_to :transaction, AssetTracker.Transactions.Transaction, type: :binary_id
    belongs_to :asset, AssetTracker.Assets.Asset, type: :binary_id
    field :units, :float
    timestamps()

    # Virtual
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:transaction_id, :asset_id, :units])
    |> validate_required([:transaction_id, :asset_id, :units])
  end

  def create_changeset(action, attrs) do
    action
    |> Map.put(:temp_id, action.temp_id || attrs["temp_id"])
    |> cast(attrs, [:asset_id, :units])
    |> validate_required([:asset_id, :units])
  end
end
