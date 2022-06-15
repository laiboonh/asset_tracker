defmodule AssetTrackerWeb.BrokerageLive.Index do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Brokerages
  alias AssetTracker.Brokerages.Brokerage
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:brokerages, list_brokerages())
     |> assign(:user_id, Utils.get_user_id(session))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Brokerage")
    |> assign(:brokerage, Brokerages.get_brokerage!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Brokerage")
    |> assign(:brokerage, %Brokerage{})
    |> assign(:user_id, socket.assigns.user_id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Brokerages")
    |> assign(:brokerage, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    brokerage = Brokerages.get_brokerage!(id)
    {:ok, _} = Brokerages.delete_brokerage(brokerage)

    {:noreply, assign(socket, :brokerages, list_brokerages())}
  end

  defp list_brokerages do
    Brokerages.list_brokerages()
  end
end
