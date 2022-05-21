defmodule AssetTracker.BrokeragesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AssetTracker.Brokerages` context.
  """

  @doc """
  Generate a brokerage.
  """
  def brokerage_fixture(attrs \\ %{}) do
    {:ok, brokerage} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> AssetTracker.Brokerages.create_brokerage()

    brokerage
  end
end
