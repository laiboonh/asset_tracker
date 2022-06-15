defmodule AssetTrackerWeb.BrokerageLive.FormComponent do
  @moduledoc false

  use AssetTrackerWeb, :live_component

  alias AssetTracker.Brokerages

  @impl true
  def update(%{brokerage: brokerage} = assigns, socket) do
    changeset = Brokerages.change_brokerage(brokerage)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"brokerage" => brokerage_params}, socket) do
    changeset =
      socket.assigns.brokerage
      |> Brokerages.change_brokerage(brokerage_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"brokerage" => brokerage_params}, socket) do
    save_brokerage(
      socket,
      socket.assigns.action,
      brokerage_params |> Map.put("user_id", socket.assigns.user_id)
    )
  end

  defp save_brokerage(socket, :edit, brokerage_params) do
    case Brokerages.update_brokerage(socket.assigns.brokerage, brokerage_params) do
      {:ok, _brokerage} ->
        {:noreply,
         socket
         |> put_flash(:info, "Brokerage updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_brokerage(socket, :new, brokerage_params) do
    case Brokerages.create_brokerage(brokerage_params) do
      {:ok, _brokerage} ->
        {:noreply,
         socket
         |> put_flash(:info, "Brokerage created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
