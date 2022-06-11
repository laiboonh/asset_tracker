defmodule AssetTracker.Repo.Migrations.CreateBrokerage do
  use Ecto.Migration

  def change do
    create table(:brokerages) do
      add :name, :string
      add :user_id, references(:users)
      timestamps()
    end
  end
end
