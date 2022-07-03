defmodule AssetTracker.Repo.Migrations.CreatePortfolios do
  use Ecto.Migration

  def change do
    create table(:portfolios, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:user_id, references(:users, type: :uuid), null: false)
      timestamps()
    end

    create(unique_index(:portfolios, [:name, :user_id]))

    create table(:portfolio_assets) do
      add(:asset_id, references(:assets, type: :uuid), null: false)
      add(:portfolio_id, references(:portfolios, type: :uuid), null: false)
    end
  end
end
