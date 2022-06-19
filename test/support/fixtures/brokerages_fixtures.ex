defmodule AssetTracker.BrokeragesFixtures do
  @moduledoc false

  import AssetTracker.AccountsFixtures

  def brokerage_fixture(attrs \\ %{}) do
    user = Map.get(attrs, :user) || user_fixture()

    {:ok, brokerage} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        name: Map.get(attrs, :name) || "some name"
      })
      |> AssetTracker.Brokerages.create_brokerage()

    brokerage
  end
end
