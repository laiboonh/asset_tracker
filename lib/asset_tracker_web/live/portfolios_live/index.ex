defmodule AssetTrackerWeb.PortfolioLive.Index do
  @moduledoc false

  use AssetTrackerWeb, :live_view

  alias AssetTracker.Portfolios
  alias AssetTracker.Portfolios.Portfolio
  alias AssetTrackerWeb.Utils

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:user_id, Utils.get_user_id(session))

    {:ok,
     socket
     |> assign(:portfolios, list_portfolios(socket.assigns.user_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    case Portfolios.get_portfolio(id, socket.assigns.user_id) do
      {:ok, portfolio} ->
        socket
        |> assign(:page_title, "Edit Portfolio")
        |> assign(:portfolio, portfolio)

      {:error, :not_found} ->
        socket
        |> put_flash(
          :info,
          "Portfolio with id #{id} not found"
        )

      {:error, :unauthorized} ->
        socket
        |> put_flash(
          :info,
          "Portfolio with id #{id} does not belong to you"
        )
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Portfolio")
    |> assign(:portfolio, %Portfolio{})
    |> assign(:user_id, socket.assigns.user_id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Portfolios")
    |> assign(:portfolio, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Portfolios.get_portfolio(id, socket.assigns.user_id) do
      {:ok, portfolio} ->
        do_delete(portfolio, socket)

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

  def do_delete(portfolio, socket) do
    case Portfolios.delete_portfolio(portfolio) do
      {:ok, portfolio} ->
        {:noreply,
         assign(
           socket |> put_flash(:info, "Portfolio #{portfolio.name} deleted successfully"),
           :portfolios,
           list_portfolios(socket.assigns.user_id)
         )}

      {:error, changeset} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           "Fail to delete Portfolio #{portfolio.name} because #{Utils.error_message(changeset)}"
         )}
    end
  end

  defp list_portfolios(user_id) do
    Portfolios.list_portfolios(user_id)
  end
end
