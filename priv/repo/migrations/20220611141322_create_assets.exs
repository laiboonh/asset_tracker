defmodule AssetTracker.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string
      add :user_id, references(:users)
      add :brokerage_id, references(:brokerages)
      timestamps()
    end
  end
end
