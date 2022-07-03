defmodule AssetTracker.Repo.Migrations.CreateBrokerage do
  use Ecto.Migration

  def change do
    create table(:brokerages, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:user_id, references(:users, type: :uuid), null: false)
      timestamps()
    end

    create(unique_index(:brokerages, [:user_id, :name]))
  end
end
