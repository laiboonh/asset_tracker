defmodule AssetTrackerWeb.TransactionLive.Show do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Transactions
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
     |> assign(:transaction, Transactions.get_transaction!(id))
     |> assign(:brokerages, brokerages(socket.assigns.user_id))}
  end

  defp brokerages(user_id) do
    Enum.map(AssetTracker.Brokerages.list_brokerages(user_id), fn brokerage ->
      [key: brokerage.name, value: brokerage.id]
    end)
  end

  defp page_title(:show), do: "Show Transaction"
  defp page_title(:edit), do: "Edit Transaction"
end
