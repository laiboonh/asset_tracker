defmodule AssetTracker.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, references(:users), null: false
      add :brokerage_id, references(:brokerages), null: false
      add :transacted_at, :date, null: false
      timestamps()
    end
  end
end
