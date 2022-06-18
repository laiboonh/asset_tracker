defmodule AssetTrackerWeb.AssetLive.Show do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Assets
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign(:user_id, Utils.get_user_id(session))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:asset, Assets.get_asset!(id))
     |> assign(:brokerages, brokerages())}
  end

  defp brokerages() do
    Enum.map(AssetTracker.Brokerages.list_brokerages(), fn brokerage ->
      [key: brokerage.name, value: brokerage.id]
    end)
  end

  defp page_title(:show), do: "Show Asset"
  defp page_title(:edit), do: "Edit Asset"
end
