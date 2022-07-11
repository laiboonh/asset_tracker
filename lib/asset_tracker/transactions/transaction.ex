defmodule AssetTracker.Transactions.Transaction do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias AssetTracker.Transactions.Action

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "transactions" do
    belongs_to :user, AssetTracker.Accounts.User, type: :binary_id
    has_many :actions, AssetTracker.Transactions.Action, on_delete: :delete_all
    field :transacted_at, :date

    field :type, Ecto.Enum,
      values: [
        :deposit,
        :rewards,
        :dividend,
        :withdrawal,
        :withholding_tax,
        :fx,
        :buy_stock,
        :sell_stock
      ]

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :transacted_at, :type])
    |> cast_assoc(:actions, required: true)
    |> validate_required([:user_id, :transacted_at, :type])
  end

  def create_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :transacted_at, :type])
    |> cast_assoc(:actions,
      required: true,
      with: &Action.create_changeset/2
    )
    |> validate_required([:user_id, :transacted_at, :type])
  end
end
