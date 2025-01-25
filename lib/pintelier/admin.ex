defmodule Pintelier.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Pintelier.Repo

  alias Pintelier.Admin.Drink

  @doc """
  Returns the list of drinks.

  ## Examples

      iex> list_drinks()
      [%Drink{}, ...]

  """
  def list_drinks do
    Repo.all(Drink)
  end

  @doc """
  Gets a single drink.

  Raises `Ecto.NoResultsError` if the Drink does not exist.

  ## Examples

      iex> get_drink!(123)
      %Drink{}

      iex> get_drink!(456)
      ** (Ecto.NoResultsError)

  """
  def get_drink!(id), do: Repo.get!(Drink, id)

  @doc """
  Creates a drink.

  ## Examples

      iex> create_drink(%{field: value})
      {:ok, %Drink{}}

      iex> create_drink(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_drink(attrs \\ %{}) do
    %Drink{}
    |> Drink.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a drink.

  ## Examples

      iex> update_drink(drink, %{field: new_value})
      {:ok, %Drink{}}

      iex> update_drink(drink, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_drink(%Drink{} = drink, attrs) do
    drink
    |> Drink.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a drink.

  ## Examples

      iex> delete_drink(drink)
      {:ok, %Drink{}}

      iex> delete_drink(drink)
      {:error, %Ecto.Changeset{}}

  """
  def delete_drink(%Drink{} = drink) do
    Repo.delete(drink)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking drink changes.

  ## Examples

      iex> change_drink(drink)
      %Ecto.Changeset{data: %Drink{}}

  """
  def change_drink(%Drink{} = drink, attrs \\ %{}) do
    Drink.changeset(drink, attrs)
  end
end
