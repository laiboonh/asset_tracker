defmodule AssetTrackerWeb.PortfolioLive.FormComponent do
  @moduledoc false

  use AssetTrackerWeb, :live_component

  alias AssetTracker.Portfolios

  @impl true
  def update(%{portfolio: portfolio} = assigns, socket) do
    changeset = Portfolios.change_portfolio(portfolio)

    {:ok,
     socket |> assign(assigns) |> assign(:changeset, changeset) |> update_assets_in_assigns()}
  end

  @impl true
  def handle_event("validate", %{"portfolio" => portfolio_params}, socket) do
    changeset =
      socket.assigns.portfolio
      |> Portfolios.change_portfolio(portfolio_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"portfolio" => portfolio_params}, socket) do
    asset_ids = Map.get(portfolio_params, "assets", [])

    save_portfolio(
      socket,
      socket.assigns.action,
      portfolio_params
      |> Map.put("user_id", socket.assigns.user_id)
      |> Map.put(
        "selected_assets",
        socket.assigns.user_id |> AssetTracker.Assets.list_assets_by_ids(asset_ids)
      )
    )
  end

  defp save_portfolio(socket, :edit, portfolio_params) do
    case Portfolios.update_portfolio(socket.assigns.portfolio, portfolio_params) do
      {:ok, _portfolio} ->
        {:noreply,
         socket
         |> put_flash(:info, "Portfolio updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_portfolio(socket, :new, portfolio_params) do
    case Portfolios.create_portfolio(portfolio_params) do
      {:ok, _portfolio} ->
        {:noreply,
         socket
         |> put_flash(:info, "Portfolio created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp update_assets_in_assigns(socket) do
    socket
    |> assign(
      :assets,
      Enum.map(
        AssetTracker.Assets.list_assets(socket.assigns.user_id),
        fn asset ->
          [key: "#{asset.name} (#{asset.brokerage.name})", value: asset.id]
        end
      )
    )
    |> assign(
      :assets_selected,
      if Ecto.assoc_loaded?(socket.assigns.portfolio.assets) do
        Enum.map(socket.assigns.portfolio.assets, & &1.id)
      else
        []
      end
    )
  end
end
