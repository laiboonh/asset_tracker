defmodule AssetTracker.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :name, :string, null: false
      add :float, :float, null: false
      add :user_id, references(:users), null: false
      add :brokerage_id, references(:brokerages), null: false
      timestamps()
    end
  end
end
