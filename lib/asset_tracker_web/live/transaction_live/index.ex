defmodule AssetTrackerWeb.TransactionLive.Index do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Transactions
  alias AssetTracker.Transactions.Transaction
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:user_id, Utils.get_user_id(session))

    {:ok,
     socket
     |> assign(:transactions, list_transactions(socket.assigns.user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case Transactions.get_transaction(id, socket.assigns.user_id) do
      {:ok, transaction} ->
        socket
        |> assign(:page_title, "Edit Transaction")
        |> assign(:transaction, transaction)
        |> assign(:brokerages, brokerages(socket.assigns.user_id))

      {:error, :not_found} ->
        socket
        |> put_flash(
          :info,
          "Transaction with id #{id} not found"
        )

      {:error, :unauthorized} ->
        socket
        |> put_flash(
          :info,
          "Transaction with id #{id} does not belong to you"
        )
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, %Transaction{
      actions: [],
      transacted_at: Date.utc_today()
    })
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:brokerages, brokerages(socket.assigns.user_id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transactions")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Transactions.delete_transaction_and_update_assets(id, socket.assigns.user_id) do
      {:ok, %{delete_transaction: transaction}} ->
        {:noreply,
         assign(
           socket
           |> put_flash(
             :info,
             "#{Utils.atom_to_string(transaction.type)} transaction deleted successfully"
           ),
           :transactions,
           list_transactions(socket.assigns.user_id)
         )}

      {:error, :not_found} ->
        socket
        |> put_flash(
          :info,
          "Transaction with id #{id} not found"
        )

      {:error, :unauthorized} ->
        socket
        |> put_flash(
          :info,
          "Transaction with id #{id} does not belong to you"
        )
    end
  end

  defp list_transactions(user_id) do
    Transactions.list_transactions(user_id)
  end

  defp brokerages(user_id) do
    Enum.map(AssetTracker.Brokerages.list_brokerages(user_id), fn brokerage ->
      [key: brokerage.name, value: brokerage.id]
    end)
  end
end
