defmodule AssetTracker.Portfolios.Portfolio do
  @moduledoc false

  @type t :: %__MODULE__{}

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "portfolios" do
    field :name, :string
    belongs_to :user, AssetTracker.Accounts.User, type: :binary_id

    many_to_many :assets, AssetTracker.Assets.Asset,
      join_through: "portfolio_assets",
      on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint([:name, :user_id])
    |> Ecto.Changeset.put_assoc(
      :assets,
      Map.get(params, :assets, []),
      :required
    )
  end
end
