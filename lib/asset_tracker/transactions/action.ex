defmodule AssetTracker.Transactions.Action do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias AssetTracker.Utils

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "actions" do
    belongs_to :transaction, AssetTracker.Transactions.Transaction, type: :binary_id
    belongs_to :asset, AssetTracker.Assets.Asset, type: :binary_id
    field :units, :decimal

    field :type, Ecto.Enum,
      values: [:transfer_in, :transfer_out, :sell_asset, :buy_asset, :commission]

    timestamps()

    # Virtual
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:transaction_id, :asset_id, :units, :type])
    |> validate_required([:transaction_id, :asset_id, :units, :type])
    |> validate_units()
  end

  def create_changeset(action, attrs) do
    action
    |> Map.put(:temp_id, action.temp_id || attrs["temp_id"])
    |> cast(attrs, [:asset_id, :units, :type])
    |> validate_required([:asset_id, :units, :type])
    |> validate_units()
  end

  @spec validate_units(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_units(changeset) do
    validate_change(changeset, :units, fn field, value ->
      type = fetch_change!(changeset, :type)

      if type in [:transfer_in, :buy_asset] do
        case Decimal.compare(value, Decimal.new(0)) do
          result when result in [:gt, :eq] ->
            []

          _others ->
            [
              {field,
               "should be positive because action type is \"#{Utils.atom_to_string(type)}\""}
            ]
        end
      else
        case Decimal.compare(value, Decimal.new(0)) do
          result when result in [:lt] ->
            []

          _others ->
            [
              {field,
               "should be negative because action type is \"#{Utils.atom_to_string(type)}\""}
            ]
        end
      end
    end)
  end
end
