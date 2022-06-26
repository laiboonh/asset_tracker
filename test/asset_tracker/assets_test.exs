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

    test "list_assets_by_brokerage/1 returns all assets" do
      asset1 = asset_fixture() |> AssetTracker.Repo.preload(:user)
      user = asset1.user
      brokerage = brokerage_fixture(%{user: user, name: "some other name"})

      asset2 = asset_fixture(%{brokerage: brokerage, name: "some other name"})
      assert Assets.list_assets_by_brokerage(asset2.brokerage.id) == [asset2]
    end

    test "get_asset!/1 returns the asset with given id" do
      asset = asset_fixture()
      assert Assets.get_asset!(asset.id) == asset
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
      assert asset.units == 10.0
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

      assert asset == Assets.get_asset!(asset.id)
    end

    test "update_units/2 with valid data increments/decrements the asset's unit" do
      asset = asset_fixture()

      assert {_num_rows_updated, _select_result} = Assets.update_units(asset.id, 1.23)

      assert {_num_rows_updated, [updated_units]} = Assets.update_units(asset.id, -1.23)

      assert updated_units === 10.0
    end
  end
end
