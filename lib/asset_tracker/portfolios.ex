defmodule AssetTracker.Portfolios do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Portfolios.Portfolio

  @spec list_portfolios(Ecto.UUID.t()) :: [Portfolio.t()]
  def list_portfolios(user_id) do
    from(Portfolio)
    |> where([b], b.user_id == ^user_id)
    |> Repo.all()
    |> Repo.preload(assets: :brokerage)
  end

  @spec get_portfolio(Ecto.UUID.t(), Ecto.UUID.t()) ::
          {:ok, Portfolio.t()} | {:error, :not_found | :unauthorized}
  def get_portfolio(id, user_id) do
    case Repo.get(Portfolio, id) |> Repo.preload(assets: :brokerage) do
      nil ->
        {:error, :not_found}

      portfolio ->
        if portfolio.user_id == user_id, do: {:ok, portfolio}, else: {:error, :unauthorized}
    end
  end

  def create_portfolio(attrs \\ %{}) do
    %Portfolio{}
    |> Portfolio.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_portfolio(Portfolio.t(), map()) ::
          {:ok, Portfolio.t()} | {:error, Ecto.Changeset.t()}
  def update_portfolio(%Portfolio{} = portfolio, attrs) do
    portfolio
    |> Portfolio.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_portfolio(Portfolio.t()) :: {:ok, Portfolio.t()} | {:error, Ecto.Changeset.t()}
  def delete_portfolio(%Portfolio{} = portfolio) do
    portfolio
    |> Portfolio.changeset(%{})
    |> Repo.delete()
  end

  def change_portfolio(%Portfolio{} = portfolio, params \\ %{}),
    do: Portfolio.changeset(portfolio, params)
end
