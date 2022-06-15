defmodule AssetTrackerWeb.BrokerageLive.Show do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Brokerages
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
     |> assign(:brokerage, Brokerages.get_brokerage!(id))}
  end

  defp page_title(:show), do: "Show Brokerage"
  defp page_title(:edit), do: "Edit Brokerage"
end
