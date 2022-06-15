defmodule AssetTrackerWeb.BrokerageLiveBrokerage do
  use AssetTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import AssetTracker.BrokeragesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_brokerage(_) do
    brokerage = brokerage_fixture()
    %{brokerage: brokerage}
  end

  describe "Index" do
    setup [:create_brokerage]

    test "lists all brokerages", %{conn: conn, brokerage: brokerage} do
      {:ok, _index_live, html} = live(conn, Routes.brokerage_index_path(conn, :index))

      assert html =~ "Listing Brokerages"
      assert html =~ brokerage.name
    end

    test "saves new brokerage", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.brokerage_index_path(conn, :index))

      assert index_live |> element("a", "New Brokerage") |> render_click() =~
               "New Brokerage"

      assert_patch(index_live, Routes.brokerage_index_path(conn, :new))

      assert index_live
             |> form("#brokerage-form", brokerage: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#brokerage-form", brokerage: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.brokerage_index_path(conn, :index))

      assert html =~ "Brokerage created successfully"
      assert html =~ "some name"
    end

    test "updates brokerage in listing", %{conn: conn, brokerage: brokerage} do
      {:ok, index_live, _html} = live(conn, Routes.brokerage_index_path(conn, :index))

      assert index_live |> element("#brokerage-#{brokerage.id} a", "Edit") |> render_click() =~
               "Edit Brokerage"

      assert_patch(index_live, Routes.brokerage_index_path(conn, :edit, brokerage))

      assert index_live
             |> form("#brokerage-form", brokerage: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#brokerage-form", brokerage: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.brokerage_index_path(conn, :index))

      assert html =~ "Brokerage updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes brokerage in listing", %{conn: conn, brokerage: brokerage} do
      {:ok, index_live, _html} = live(conn, Routes.brokerage_index_path(conn, :index))

      assert index_live |> element("#brokerage-#{brokerage.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#brokerage-#{brokerage.id}")
    end
  end

  describe "Show" do
    setup [:create_brokerage]

    test "displays brokerage", %{conn: conn, brokerage: brokerage} do
      {:ok, _show_live, html} = live(conn, Routes.brokerage_show_path(conn, :show, brokerage))

      assert html =~ "Show Brokerage"
      assert html =~ brokerage.name
    end

    test "updates brokerage within modal", %{conn: conn, brokerage: brokerage} do
      {:ok, show_live, _html} = live(conn, Routes.brokerage_show_path(conn, :show, brokerage))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Brokerage"

      assert_patch(show_live, Routes.brokerage_show_path(conn, :edit, brokerage))

      assert show_live
             |> form("#brokerage-form", brokerage: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#brokerage-form", brokerage: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.brokerage_show_path(conn, :show, brokerage))

      assert html =~ "Brokerage updated successfully"
      assert html =~ "some updated name"
    end
  end
end
