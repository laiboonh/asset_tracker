defmodule AssetTracker.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :transaction_id, references(:transactions)
      add :asset_id, references(:assets)
      add :units, :float
      timestamps()
    end
  end
end
