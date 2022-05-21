defmodule AssetTracker.Brokerages.Schema.Brokerage do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "brokerage" do
    field :name, :string

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(brokerage, attrs) do
    brokerage
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
