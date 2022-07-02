defmodule AssetTracker.AssetsTest do
  use AssetTracker.DataCase

  alias AssetTracker.Assets
  alias AssetTracker.Assets.Asset

  import AssetTracker.AssetsFixtures
  import AssetTracker.BrokeragesFixtures

  describe "assets" do
    @invalid_attrs %{name: nil}

    test "list_assets/1 returns all assets belonging to user_id" do
      asset = asset_fixture()
      assert Assets.list_assets(asset.user_id) == [asset]
    end

    test "list_assets_by_brokerage/2 returns all assets" do
      asset1 = asset_fixture() |> AssetTracker.Repo.preload(:user)
      user = asset1.user

      brokerage = brokerage_fixture(%{user: user, name: "some other name"})
      asset2 = asset_fixture(%{brokerage: brokerage, name: "some other name"})

      assert Assets.list_assets_by_brokerage(asset2.brokerage.id, asset2.user_id) == [asset2]
    end

    test "get_asset/2 returns the asset with given id" do
      asset = asset_fixture()
      assert Assets.get_asset(asset.id, asset.user_id) == {:ok, asset}
    end

    test "create_asset/1 with valid data creates a asset" do
      brokerage = brokerage_fixture() |> AssetTracker.Repo.preload(:user)

      valid_attrs = %{
        name: "some name",
        units: 10.0,
        user_id: brokerage.user.id,
        brokerage_id: brokerage.id
      }

      assert {:ok, %Asset{} = asset} = Assets.create_asset(valid_attrs)
      assert asset.name == "some name"
      assert asset.units == Decimal.from_float(10.0)
    end

    test "create_asset/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assets.create_asset(@invalid_attrs)
    end

    test "update_asset/2 with valid data updates the asset" do
      asset = asset_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Asset{} = asset} = Assets.update_asset(asset, update_attrs)

      assert asset.name == "some updated name"
    end

    test "update_asset/2 with invalid data returns error changeset" do
      asset = asset_fixture()

      assert {:error, %Ecto.Changeset{}} = Assets.update_asset(asset, @invalid_attrs)

      assert Assets.get_asset(asset.id, asset.user_id) == {:ok, asset}
    end

    test "update_units/2 with valid data increments/decrements the asset's unit" do
      asset = asset_fixture()

      assert {_num_rows_updated, _select_result} =
               Assets.update_units(asset.id, Decimal.from_float(1.23))

      assert {_num_rows_updated, [updated_units]} =
               Assets.update_units(asset.id, Decimal.from_float(-1.23))

      assert updated_units == Decimal.new("10.00")
    end

    test "total_cost/1 returns cost of asset" do
      asset =
        asset_fixture(%{name: "QQQ", units: 0.0})
        |> AssetTracker.Repo.preload([:user, :brokerage])

      money =
        asset_fixture(%{brokerage: asset.brokerage, name: "USD", units: 100.0})
        |> AssetTracker.Repo.preload([:user, :brokerage])

      valid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        type: :buy_asset,
        actions: [
          %{
            asset_id: asset.id,
            units: 10.0,
            type: :buy_asset
          },
          %{
            asset_id: money.id,
            units: -50.0,
            type: :sell_asset
          }
        ]
      }

      assert {:ok, _results} =
               AssetTracker.Transactions.create_transaction_update_assets(valid_attrs)

      valid_attrs = %{
        user_id: asset.user.id,
        brokerage_id: asset.brokerage.id,
        transacted_at: Date.utc_today(),
        type: :sell_asset,
        actions: [
          %{
            asset_id: asset.id,
            units: -5.0,
            type: :sell_asset
          },
          %{
            asset_id: money.id,
            units: 20.0,
            type: :buy_asset
          }
        ]
      }

      assert {:ok, _results} =
               AssetTracker.Transactions.create_transaction_update_assets(valid_attrs)

      # check assets' units
      {:ok, %Asset{name: "USD", units: asset_units}} = Assets.get_asset(money.id, asset.user_id)
      assert asset_units == Decimal.from_float(70.0)

      {:ok, %Asset{name: "QQQ", units: asset_units}} = Assets.get_asset(asset.id, asset.user_id)
      assert asset_units == Decimal.from_float(5.0)

      assert Assets.total_cost(asset.id) == [
               {:buy_asset, "QQQ", Decimal.from_float(10.0)},
               {:sell_asset, "USD", Decimal.from_float(-50.0)}
             ]
    end
  end
end
