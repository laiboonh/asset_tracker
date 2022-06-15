defmodule AssetTrackerWeb.BrokerageLive.Index do
  use AssetTrackerWeb, :live_view

  alias AssetTracker.Brokerages
  alias AssetTracker.Brokerages.Brokerage

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:brokerages, list_brokerages())}
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
    IO.inspect(socket)
    # user = AssetTracker.Accounts.get_user_by_session_token(user_token)
    # IO.inspect(user)

    socket
    |> assign(:page_title, "New Brokerage")
    |> assign(:brokerage, %Brokerage{})
    |> assign(:user_id, 1)
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
