defmodule AssetTracker.Brokerages.Brokerage do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "brokerages" do
    field :name, :string
    belongs_to :user, AssetTracker.Accounts.User
    has_many :assets, AssetTracker.Assets.Asset

    timestamps()
  end

  @doc false
  def changeset(brokerage, params) do
    brokerage
    |> cast(params, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:assets,
      name: :assets_brokerage_id_fkey,
      message: "exist with this brokerage"
    )
  end
end
