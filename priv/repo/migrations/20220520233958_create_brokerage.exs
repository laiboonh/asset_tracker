defmodule AssetTracker.Repo.Migrations.CreateBrokerage do
  use Ecto.Migration

  def change do
    create table(:brokerage, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end
