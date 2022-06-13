defmodule AssetTracker.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :transaction_id, references(:transactions, on_delete: :delete_all), null: false
      add :asset_id, references(:assets), null: false
      add :units, :float, null: false
      timestamps()
    end
  end
end
