defmodule AssetTracker.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:transaction_id, references(:transactions, type: :uuid, on_delete: :delete_all),
        null: false
      )

      add(:asset_id, references(:assets, type: :uuid), null: false)
      add(:type, :binary, null: false)
      add(:units, :float, null: false)
      timestamps()
    end
  end
end
