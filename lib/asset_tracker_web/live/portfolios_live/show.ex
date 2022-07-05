defmodule AssetTrackerWeb.PortfolioLive.Show do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Portfolios
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    {:ok, socket |> assign(:user_id, Utils.get_user_id(session))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    case Portfolios.get_portfolio(id, socket.assigns.user_id) do
      {:ok, portfolio} ->
        {:noreply,
         socket
         |> assign(:page_title, page_title(socket.assigns.live_action))
         |> assign(:portfolio, portfolio)}

      {:error, :not_found} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Portfolio with id #{id} not found"
         )}

      {:error, :unauthorized} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Portfolio with id #{id} does not belong to you"
         )}
    end
  end

  defp page_title(:show), do: "Show Portfolio"
  defp page_title(:edit), do: "Edit Portfolio"
end
