defmodule AssetTracker.BrokeragesFixtures do
  @moduledoc false

  import AssetTracker.AccountsFixtures

  def brokerage_fixture(attrs \\ %{}) do
    user = Map.get(attrs, :user) || user_fixture()

    {:ok, brokerage} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        name: "brokerage#{System.unique_integer()}"
      })
      |> AssetTracker.Brokerages.create_brokerage()

    brokerage
  end
end
