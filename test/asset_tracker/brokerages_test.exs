defmodule AssetTracker.BrokeragesTest do
  use AssetTracker.DataCase

  alias AssetTracker.Brokerages
  alias AssetTracker.Brokerages.Brokerage

  import AssetTracker.AccountsFixtures
  import AssetTracker.BrokeragesFixtures

  describe "brokerages" do
    @invalid_attrs %{name: nil}

    test "list_brokerage/0 returns all brokerage" do
      brokerage = brokerage_fixture()
      assert Brokerages.list_brokerage() == [brokerage]
    end

    test "get_brokerage!/1 returns the brokerage with given id" do
      brokerage = brokerage_fixture()
      assert Brokerages.get_brokerage!(brokerage.id) == brokerage
    end

    test "create_brokerage/1 with valid data creates a brokerage" do
      user = user_fixture()
      valid_attrs = %{name: "some name", user_id: user.id}

      assert {:ok, %Brokerage{} = brokerage} = Brokerages.create_brokerage(valid_attrs)
      assert brokerage.name == "some name"
    end

    test "create_brokerage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Brokerages.create_brokerage(@invalid_attrs)
    end

    test "update_brokerage/2 with valid data updates the brokerage" do
      brokerage = brokerage_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Brokerage{} = brokerage} =
               Brokerages.update_brokerage(brokerage, update_attrs)

      assert brokerage.name == "some updated name"
    end

    test "update_brokerage/2 with invalid data returns error changeset" do
      brokerage = brokerage_fixture()

      assert {:error, %Ecto.Changeset{}} = Brokerages.update_brokerage(brokerage, @invalid_attrs)

      assert brokerage == Brokerages.get_brokerage!(brokerage.id)
    end
  end
end
