defmodule AssetTrackerWeb.BrokerageLive.Index do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Brokerages
  alias AssetTracker.Brokerages.Brokerage
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:user_id, Utils.get_user_id(session))

    {:ok,
     socket
     |> assign(:brokerages, list_brokerages(socket.assigns.user_id))}
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

    case Brokerages.delete_brokerage(brokerage) do
      {:ok, brokerage} ->
        {:noreply,
         assign(
           socket |> put_flash(:info, "Brokerage #{brokerage.name} deleted successfully"),
           :brokerages,
           list_brokerages(socket.assigns.user_id)
         )}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Fail to delete Brokerage #{brokerage.name} because #{Utils.error_message(changeset)}"
         )}
    end
  end

  defp list_brokerages(user_id) do
    Brokerages.list_brokerages(user_id)
  end
end
