defmodule AssetTracker.Repo.Migrations.CreateTransations do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user_id, references(:users)
      add :brokerage_id, references(:brokerages)
      add :transacted_at, :date
      timestamps()
    end
  end
end
