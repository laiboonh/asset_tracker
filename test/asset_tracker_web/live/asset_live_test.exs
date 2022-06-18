defmodule AssetTrackerWeb.AssetLiveAsset do
  use AssetTrackerWeb.ConnCase
  use Mimic

  import Phoenix.LiveViewTest
  import AssetTracker.AssetsFixtures

  @create_attrs %{name: "IBKR"}
  @update_attrs %{name: "SYFE"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    asset = asset_fixture() |> AssetTracker.Repo.preload([:user, :brokerage])

    %{conn: conn |> log_in_user(asset.user), asset: asset}
  end

  describe "Index" do
    test "lists all assets", %{conn: conn, asset: asset} do
      {:ok, _index_live, html} = live(conn, Routes.asset_index_path(conn, :index))

      assert html =~ "Listing Assets"
      assert html =~ asset.name
    end

    test "saves new asset", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.asset_index_path(conn, :index))

      assert index_live |> element("a", "New Asset") |> render_click() =~
               "New Asset"

      assert_patch(index_live, Routes.asset_index_path(conn, :new))

      assert index_live
             |> form("#asset-form", asset: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#asset-form", asset: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.asset_index_path(conn, :index))

      assert html =~ "Asset created successfully"
      assert html =~ "some name"
    end

    test "updates asset in listing", %{conn: conn, asset: asset} do
      {:ok, index_live, _html} = live(conn, Routes.asset_index_path(conn, :index))

      assert index_live |> element("#asset-#{asset.id} a", "Edit") |> render_click() =~
               "Edit Asset"

      assert_patch(index_live, Routes.asset_index_path(conn, :edit, asset))

      assert index_live
             |> form("#asset-form", asset: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#asset-form", asset: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.asset_index_path(conn, :index))

      assert html =~ "Asset updated successfully"
      assert html =~ "SYFE"
    end

    test "deletes asset in listing", %{conn: conn, asset: asset} do
      {:ok, index_live, _html} = live(conn, Routes.asset_index_path(conn, :index))

      assert index_live |> element("#asset-#{asset.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#asset-#{asset.id}")
    end
  end

  describe "Show" do
    test "displays asset", %{conn: conn, asset: asset} do
      {:ok, _show_live, html} = live(conn, Routes.asset_show_path(conn, :show, asset))

      assert html =~ "Show Asset"
      assert html =~ asset.name
    end

    test "updates asset within modal", %{conn: conn, asset: asset} do
      {:ok, show_live, _html} = live(conn, Routes.asset_show_path(conn, :show, asset))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Asset"

      assert_patch(show_live, Routes.asset_show_path(conn, :edit, asset))

      assert show_live
             |> form("#asset-form",
               asset: @invalid_attrs |> Map.put(:brokerage_id, asset.brokerage.id)
             )
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#asset-form", asset: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.asset_show_path(conn, :show, asset))

      assert html =~ "Asset updated successfully"
      assert html =~ "SYFE"
    end
  end
end
