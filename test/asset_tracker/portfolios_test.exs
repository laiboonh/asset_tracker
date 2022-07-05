defmodule AssetTracker.PortfolioTest do
  use AssetTracker.DataCase

  alias AssetTracker.Portfolios
  alias AssetTracker.Portfolios.Portfolio

  import AssetTracker.AccountsFixtures
  import AssetTracker.BrokeragesFixtures
  import AssetTracker.AssetsFixtures
  import AssetTracker.PortfoliosFixtures

  describe "portfolios" do
    @invalid_attrs %{name: nil}

    test "list_portfolios/1 returns all portfolio belonging to user_id" do
      portfolio = portfolio_fixture()
      portfolio_id = portfolio.id

      _another_portfolio = portfolio_fixture()

      assert [%Portfolio{id: ^portfolio_id, assets: assets}] =
               Portfolios.list_portfolios(portfolio.user_id)

      assert length(assets) == 1
    end

    test "get_portfolio/2 returns the portfolio with given id" do
      portfolio = portfolio_fixture()
      {:ok, result} = Portfolios.get_portfolio(portfolio.id, portfolio.user_id)
      assert result.id == portfolio.id
    end

    test "create_portfolio/1 with valid data creates a portfolio" do
      user = user_fixture()
      brokerage = brokerage_fixture(%{user: user})
      asset = asset_fixture(%{brokerage: brokerage})

      valid_attrs = %{
        name: "some name",
        user_id: user.id,
        assets: [asset]
      }

      assert {:ok, %Portfolio{} = portfolio} = Portfolios.create_portfolio(valid_attrs)
      assert portfolio.name == "some name"
    end

    test "create_portfolio/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Portfolios.create_portfolio(@invalid_attrs)
    end

    test "update_portfolio/2 with valid data updates the portfolio" do
      portfolio = portfolio_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Portfolio{} = portfolio} =
               Portfolios.update_portfolio(portfolio, update_attrs)

      assert portfolio.name == "some updated name"
    end

    test "update_portfolio/2 with invalid data returns error changeset" do
      portfolio = portfolio_fixture()

      assert {:error, %Ecto.Changeset{}} = Portfolios.update_portfolio(portfolio, @invalid_attrs)

      {:ok, result} = Portfolios.get_portfolio(portfolio.id, portfolio.user_id)

      assert portfolio.id == result.id
    end

    test "delete_portfolio/1 with valid data deletes the portfolio" do
      portfolio = portfolio_fixture()

      # remove association
      assert {:ok, %Portfolio{}} = Portfolios.update_portfolio(portfolio, %{assets: []})

      assert {:ok, %Portfolio{}} = Portfolios.delete_portfolio(portfolio)
      assert Portfolios.get_portfolio(portfolio.id, portfolio.user_id) == {:error, :not_found}
    end

    test "change_portfolio/1 returns a test changeset" do
      portfolio = portfolio_fixture()
      assert %Ecto.Changeset{} = Portfolios.change_portfolio(portfolio)
    end
  end
end
