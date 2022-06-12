defmodule AssetTracker.AssetsTest do
  use AssetTracker.DataCase

  alias AssetTracker.Assets
  alias AssetTracker.Assets.Asset

  import AssetTracker.AssetsFixtures
  import AssetTracker.BrokeragesFixtures

  describe "assets" do
    @invalid_attrs %{name: nil}

    test "list_assets/0 returns all assets" do
      asset = asset_fixture()
      assert Assets.list_assets() == [asset]
    end

    test "get_asset!/1 returns the asset with given id" do
      asset = asset_fixture()
      assert Assets.get_asset!(asset.id) == asset
    end

    test "create_asset/1 with valid data creates a asset" do
      brokerage = brokerage_fixture() |> AssetTracker.Repo.preload(:user)

      valid_attrs = %{name: "some name", user_id: brokerage.user.id, brokerage_id: brokerage.id}

      assert {:ok, %Asset{} = asset} = Assets.create_asset(valid_attrs)
      assert asset.name == "some name"
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
  end
end