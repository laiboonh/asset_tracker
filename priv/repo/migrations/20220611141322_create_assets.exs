defmodule AssetTracker.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:units, :decimal, null: false)
      add(:user_id, references(:users, type: :uuid), null: false)
      add(:brokerage_id, references(:brokerages, type: :uuid), null: false)
      timestamps()
    end

    create(unique_index(:assets, [:brokerage_id, :name, :user_id]))
  end
end
