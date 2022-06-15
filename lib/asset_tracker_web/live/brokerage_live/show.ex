defmodule AssetTrackerWeb.BrokerageLive.Show do
  use AssetTrackerWeb, :live_view

  alias AssetTracker.Brokerages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:brokerage, Brokerages.get_brokerage!(id))}
  end

  defp page_title(:show), do: "Show Brokerage"
  defp page_title(:edit), do: "Edit Brokerage"
end
