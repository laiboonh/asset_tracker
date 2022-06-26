defmodule AssetTrackerWeb.AssetLive.Index do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Assets
  alias AssetTracker.Assets.Asset
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:user_id, Utils.get_user_id(session))

    {:ok,
     socket
     |> assign(:assets, Assets.list_assets(socket.assigns.user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case Assets.get_asset(id, socket.assigns.user_id) do
      {:ok, asset} ->
        socket
        |> assign(:page_title, "Edit Asset")
        |> assign(:asset, asset)
        |> assign(:brokerages, brokerages(socket.assigns.user_id))

      {:error, :not_found} ->
        socket
        |> put_flash(
          :info,
          "Asset with id #{id} not found"
        )

      {:error, :unauthorized} ->
        socket
        |> put_flash(
          :info,
          "Asset with id #{id} does not belong to you"
        )
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Asset")
    |> assign(:asset, %Asset{})
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:brokerages, brokerages(socket.assigns.user_id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Assets")
    |> assign(:asset, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Assets.get_asset(id, socket.assigns.user_id) do
      {:ok, asset} ->
        do_delete(asset, socket)

      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Asset with id #{id} not found"
         )}

      {:error, :unauthorized} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Asset with id #{id} does not belong to you"
         )}
    end
  end

  def do_delete(asset, socket) do
    case Assets.delete_asset(asset) do
      {:ok, asset} ->
        {:noreply,
         assign(
           socket |> put_flash(:info, "Asset #{asset.name} deleted successfully"),
           :assets,
           Assets.list_assets(socket.assigns.user_id)
         )}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Fail to delete Asset #{asset.name} because #{Utils.error_message(changeset)}"
         )}
    end
  end

  defp brokerages(user_id) do
    Enum.map(AssetTracker.Brokerages.list_brokerages(user_id), fn brokerage ->
      [key: brokerage.name, value: brokerage.id]
    end)
  end
end
