defmodule AssetTracker.Assets.Asset do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "assets" do
    field :name, :string
    belongs_to :user, AssetTracker.Accounts.User
    belongs_to :brokerage, AssetTracker.Brokerages.Brokerage

    timestamps()
  end

  @doc false
  def changeset(brokerage, attrs) do
    brokerage
    |> cast(attrs, [:name, :user_id, :brokerage_id])
    |> validate_required([:name, :user_id, :brokerage_id])
  end
end
