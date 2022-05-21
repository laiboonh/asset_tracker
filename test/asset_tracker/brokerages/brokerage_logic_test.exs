defmodule AssetTracker.BrokeragesTest do
  use AssetTracker.DataCase

  alias AssetTracker.Brokerages.BrokerageLogic

  describe "brokerage" do
    alias AssetTracker.Brokerages.Schema.Brokerage

    import AssetTracker.BrokeragesFixtures

    @invalid_attrs %{name: nil}

    test "list_brokerage/0 returns all brokerage" do
      brokerage = brokerage_fixture()
      assert BrokerageLogic.list_brokerage() == [brokerage]
    end

    test "get_brokerage!/1 returns the brokerage with given id" do
      brokerage = brokerage_fixture()
      assert BrokerageLogic.get_brokerage!(brokerage.id) == brokerage
    end

    test "create_brokerage/1 with valid data creates a brokerage" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Brokerage{} = brokerage} = BrokerageLogic.create_brokerage(valid_attrs)
      assert brokerage.name == "some name"
    end

    test "create_brokerage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BrokerageLogic.create_brokerage(@invalid_attrs)
    end

    test "update_brokerage/2 with valid data updates the brokerage" do
      brokerage = brokerage_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Brokerage{} = brokerage} =
               BrokerageLogic.update_brokerage(brokerage, update_attrs)

      assert brokerage.name == "some updated name"
    end

    test "update_brokerage/2 with invalid data returns error changeset" do
      brokerage = brokerage_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BrokerageLogic.update_brokerage(brokerage, @invalid_attrs)

      assert brokerage == BrokerageLogic.get_brokerage!(brokerage.id)
    end

    test "delete_brokerage/1 deletes the brokerage" do
      brokerage = brokerage_fixture()
      assert {:ok, %Brokerage{}} = BrokerageLogic.delete_brokerage(brokerage)
      assert_raise Ecto.NoResultsError, fn -> BrokerageLogic.get_brokerage!(brokerage.id) end
    end

    test "change_brokerage/1 returns a brokerage changeset" do
      brokerage = brokerage_fixture()
      assert %Ecto.Changeset{} = BrokerageLogic.change_brokerage(brokerage)
    end
  end
end
