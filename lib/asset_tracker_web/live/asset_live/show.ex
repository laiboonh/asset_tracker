defmodule AssetTrackerWeb.AssetLive.Show do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Assets
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign(:user_id, Utils.get_user_id(session))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case Assets.get_asset(id, socket.assigns.user_id) do
      {:ok, asset} ->
        total_costs = Assets.total_costs(id)

        {:noreply,
         socket
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:asset, asset)
         |> assign(:brokerages, brokerages(socket.assigns.user_id))
         |> assign(:total_costs, total_costs)
         |> average_cost(total_costs)}

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

  defp average_cost(socket, total_costs) do
    average_cost = Assets.average_cost(total_costs)

    if average_cost != nil do
      {average_cost_asset, average_cost_units} = average_cost

      socket
      |> assign(:average_cost_asset, average_cost_asset)
      |> assign(:average_cost_units, average_cost_units |> Decimal.round(5))
    else
      socket
      |> assign(:average_cost_asset, nil)
      |> assign(:average_cost_units, nil)
    end
  end

  defp brokerages(user_id) do
    Enum.map(AssetTracker.Brokerages.list_brokerages(user_id), fn brokerage ->
      [key: brokerage.name, value: brokerage.id]
    end)
  end

  defp page_title(:show), do: "Show Asset"
  defp page_title(:edit), do: "Edit Asset"
end
