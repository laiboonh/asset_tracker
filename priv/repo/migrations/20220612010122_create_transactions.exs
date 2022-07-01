defmodule AssetTracker.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, type: :uuid), null: false)
      add(:brokerage_id, references(:brokerages, type: :uuid), null: false)
      add(:transacted_at, :date, null: false)
      add(:type, :binary, null: false)
      timestamps()
    end
  end
end
