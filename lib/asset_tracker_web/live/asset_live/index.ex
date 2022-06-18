defmodule AssetTrackerWeb.AssetLive.Index do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Assets
  alias AssetTracker.Assets.Asset
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(:assets, list_assets())
     |> assign(:user_id, Utils.get_user_id(session))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Asset")
    |> assign(:asset, Assets.get_asset!(id))
    |> assign(:brokerages, brokerages())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Asset")
    |> assign(:asset, %Asset{})
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:brokerages, brokerages())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Assets")
    |> assign(:asset, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    asset = Assets.get_asset!(id)
    {:ok, _} = Assets.delete_asset(asset)

    {:noreply, assign(socket, :assets, list_assets())}
  end

  defp list_assets do
    Assets.list_assets()
  end

  defp brokerages() do
    Enum.map(AssetTracker.Brokerages.list_brokerages(), fn brokerage ->
      [key: brokerage.name, value: brokerage.id]
    end)
  end
end
