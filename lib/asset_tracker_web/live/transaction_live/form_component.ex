defmodule AssetTrackerWeb.TransactionLive.FormComponent do
  @moduledoc false

  use AssetTrackerWeb, :live_component

  alias AssetTracker.Transactions
  alias AssetTracker.Transactions.Action
  alias AssetTrackerWeb.Utils

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> update_assets_in_assigns()
     |> update_tx_types_in_assigns
     |> update_action_types_in_assigns()}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    transaction_params = maybe_format_actions_param(transaction_params)

    changeset =
      socket.assigns.transaction
      |> Transactions.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket, :changeset, changeset)
     |> update_assets_in_assigns()
     |> update_tx_types_in_assigns
     |> update_action_types_in_assigns()}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(
      socket,
      socket.assigns.action,
      transaction_params
      |> Map.merge(%{"user_id" => socket.assigns.user_id})
    )
  end

  def handle_event("add-action", _params, socket) do
    existing_actions =
      Map.get(socket.assigns.changeset.changes, :actions, socket.assigns.transaction.actions)

    actions =
      existing_actions
      |> Enum.concat([
        # NOTE temp_id
        Transactions.change_action(%Action{temp_id: get_temp_id()})
      ])

    changeset = socket.assigns.changeset |> Ecto.Changeset.put_assoc(:actions, actions)

    {:noreply,
     assign(socket, changeset: changeset)
     |> update_assets_in_assigns()
     |> update_tx_types_in_assigns
     |> update_action_types_in_assigns()}
  end

  def handle_event("remove-action", %{"remove" => remove_id}, socket) do
    actions =
      socket.assigns.changeset.changes.actions
      |> Enum.reject(fn %{data: action} ->
        action.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:actions, actions)

    {:noreply, assign(socket, changeset: changeset)}
  end

  defp save_transaction(socket, :new, transaction_params) do
    case Transactions.create_transaction_update_assets(transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, failed_operation, _failed_value, _changes_so_far} ->
        {:noreply,
         socket
         |> put_flash(:error, "Fail to create transaction. Failed operation: #{failed_operation}")
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)

  defp update_assets_in_assigns(socket) do
    brokerage_id =
      Map.get(
        socket.assigns.changeset.changes,
        :brokerage_id,
        hd(socket.assigns.brokerages) |> Keyword.get(:value)
      )

    assign(
      socket,
      :assets,
      Enum.map(
        AssetTracker.Assets.list_assets_by_brokerage(brokerage_id, socket.assigns.user_id),
        fn asset ->
          [key: "#{asset.name} (#{asset.brokerage.name})", value: asset.id]
        end
      )
    )
  end

  defp update_tx_types_in_assigns(socket) do
    assign(
      socket,
      :tx_types,
      Enum.map(
        Ecto.Enum.values(AssetTracker.Transactions.Transaction, :type),
        fn type ->
          [
            key: Utils.atom_to_string(type),
            value: type
          ]
        end
      )
    )
  end

  defp update_action_types_in_assigns(socket) do
    assign(
      socket,
      :action_types,
      Enum.map(
        Ecto.Enum.values(AssetTracker.Transactions.Action, :type),
        fn type ->
          [
            key: Utils.atom_to_string(type),
            value: type
          ]
        end
      )
    )
  end

  defp maybe_format_actions_param(transaction_params) do
    if Map.has_key?(transaction_params, "actions") do
      Map.update!(transaction_params, "actions", fn existing_value ->
        Map.values(existing_value)
      end)
    else
      transaction_params
    end
  end
end
