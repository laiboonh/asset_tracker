defmodule AssetTrackerWeb.TransactionLive.FormComponent do
  @moduledoc false

  use AssetTrackerWeb, :live_component

  alias AssetTracker.Transactions
  alias AssetTracker.Transactions.Action

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    transaction_params = maybe_format_actions_param(transaction_params)

    changeset =
      socket.assigns.transaction
      |> Transactions.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset) |> update_assets_in_assigns()}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(
      socket,
      socket.assigns.action,
      transaction_params
      |> Map.merge(%{"user_id" => socket.assigns.user_id})
    )
  end

  def handle_event("add-action", _, socket) do
    existing_actions =
      Map.get(socket.assigns.changeset.changes, :actions, socket.assigns.transaction.actions)

    actions =
      existing_actions
      |> Enum.concat([
        # NOTE temp_id
        Transactions.change_action(%Action{temp_id: get_temp_id()})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:actions, actions)

    {:noreply, assign(socket, changeset: changeset)}
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

  defp save_transaction(socket, :edit, transaction_params) do
    case Transactions.update_transaction(socket.assigns.transaction, transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Asset updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    case Transactions.create_transaction(transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Asset created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)

  defp update_assets_in_assigns(socket) do
    brokerage_id = socket.assigns.changeset.changes.brokerage_id

    assign(socket, :assets, assets(brokerage_id))
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

  defp assets(brokerage_id) do
    Enum.map(AssetTracker.Assets.list_assets_by_brokerage(brokerage_id), fn asset ->
      [key: "#{asset.name} (#{asset.brokerage.name})", value: asset.id]
    end)
  end
end
