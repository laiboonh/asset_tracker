defmodule AssetTracker.Transactions.Transaction do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias AssetTracker.Transactions.Action

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "transactions" do
    belongs_to :brokerage, AssetTracker.Brokerages.Brokerage, type: :binary_id
    belongs_to :user, AssetTracker.Accounts.User, type: :binary_id
    has_many :actions, AssetTracker.Transactions.Action, on_delete: :delete_all
    field :transacted_at, :date
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :brokerage_id, :transacted_at])
    |> cast_assoc(:actions, required: true)
    |> validate_required([:user_id, :brokerage_id, :transacted_at])
  end

  def create_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :brokerage_id, :transacted_at])
    |> cast_assoc(:actions,
      required: true,
      with: &Action.create_changeset/2
    )
    |> validate_required([:user_id, :brokerage_id, :transacted_at])
  end
end
