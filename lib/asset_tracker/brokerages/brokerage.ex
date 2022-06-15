defmodule AssetTracker.Brokerages.Brokerage do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "brokerages" do
    field :name, :string
    belongs_to :user, AssetTracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(brokerage, params) do
    brokerage
    |> cast(params, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
