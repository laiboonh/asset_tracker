defmodule AssetTracker.BrokeragesFixtures do
  @moduledoc false

  import AssetTracker.AccountsFixtures

  def brokerage_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, brokerage} =
      attrs
      |> Enum.into(%{
        user_id: user.id,
        name: "some name"
      })
      |> AssetTracker.Brokerages.create_brokerage()

    brokerage
  end
end
