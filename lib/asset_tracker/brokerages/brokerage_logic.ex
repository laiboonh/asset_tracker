defmodule AssetTracker.Brokerages.BrokerageLogic do
  @moduledoc false

  import Ecto.Query, warn: false
  alias AssetTracker.Repo

  alias AssetTracker.Brokerages.Schema.Brokerage

  @doc """
  Returns the list of brokerage.

  ## Examples

      iex> list_brokerage()
      [%Brokerage{}, ...]

  """
  def list_brokerage do
    Repo.all(Brokerage)
  end

  @doc """
  Gets a single brokerage.

  Raises `Ecto.NoResultsError` if the Brokerage does not exist.

  ## Examples

      iex> get_brokerage!(123)
      %Brokerage{}

      iex> get_brokerage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brokerage!(id), do: Repo.get!(Brokerage, id)

  @doc """
  Creates a brokerage.

  ## Examples

      iex> create_brokerage(%{field: value})
      {:ok, %Brokerage{}}

      iex> create_brokerage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brokerage(attrs \\ %{}) do
    %Brokerage{}
    |> Brokerage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a brokerage.

  ## Examples

      iex> update_brokerage(brokerage, %{field: new_value})
      {:ok, %Brokerage{}}

      iex> update_brokerage(brokerage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_brokerage(%Brokerage{} = brokerage, attrs) do
    brokerage
    |> Brokerage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a brokerage.

  ## Examples

      iex> delete_brokerage(brokerage)
      {:ok, %Brokerage{}}

      iex> delete_brokerage(brokerage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_brokerage(%Brokerage{} = brokerage) do
    Repo.delete(brokerage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brokerage changes.

  ## Examples

      iex> change_brokerage(brokerage)
      %Ecto.Changeset{data: %Brokerage{}}

  """
  def change_brokerage(%Brokerage{} = brokerage, attrs \\ %{}) do
    Brokerage.changeset(brokerage, attrs)
  end
end
