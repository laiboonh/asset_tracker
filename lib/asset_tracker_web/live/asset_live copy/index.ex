defmodule AssetTrackerWeb.TransactionLive.Index do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Transactions
  alias AssetTracker.Transactions.Transaction
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:transactions, list_transactions())
     |> assign(:user_id, Utils.get_user_id(session))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:transaction, Transactions.get_transaction!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, %Transaction{actions: []})
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:brokerages, brokerages())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transactions")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _} = Transactions.delete_transaction_and_update_assets(id)

    {:noreply, assign(socket, :transactions, list_transactions())}
  end

  defp list_transactions do
    Transactions.list_transactions()
  end

  defp brokerages do
    Enum.map(AssetTracker.Brokerages.list_brokerages(), fn brokerage ->
      [key: brokerage.name, value: brokerage.id]
    end)
  end
end
