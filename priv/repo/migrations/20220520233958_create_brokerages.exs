defmodule AssetTracker.Repo.Migrations.CreateBrokerage do
  use Ecto.Migration

  def change do
    create table(:brokerages) do
      add :name, :string, null: false
      add :user_id, references(:users), null: false
      timestamps()
    end

    create unique_index(:brokerages, [:name])
  end
end
