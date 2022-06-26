defmodule AssetTracker.Assets.Asset do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "assets" do
    field :name, :string
    field :units, :float
    belongs_to :user, AssetTracker.Accounts.User, type: :binary_id
    belongs_to :brokerage, AssetTracker.Brokerages.Brokerage, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(brokerage, attrs) do
    brokerage
    |> cast(attrs, [:name, :units, :user_id, :brokerage_id])
    |> validate_required([:name, :units, :user_id, :brokerage_id])
    |> unique_constraint([:brokerage_id, :name])
  end
end
