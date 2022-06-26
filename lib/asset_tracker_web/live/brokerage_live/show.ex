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
    case Brokerages.get_brokerage(id, socket.assigns.user_id) do
      {:ok, brokerage} ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:brokerage, brokerage)}

      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Brokerage with id #{id} not found"
         )}

      {:error, :unauthorized} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Brokerage with id #{id} does not belong to you"
         )}
    end
  end

  defp page_title(:show), do: "Show Brokerage"
  defp page_title(:edit), do: "Edit Brokerage"
end
