defmodule Pintelier.Drinking do
  @moduledoc """
  The Drinking context.
  """

  import Ecto.Query, warn: false
  alias Pintelier.Repo

  alias Pintelier.Drinking.Consumption

  @doc """
  Returns the list of consumptions.

  ## Examples

      iex> list_consumptions()
      [%Consumption{}, ...]

  """
  def list_consumptions do
    Repo.all(from c in Consumption, order_by: [desc: c.inserted_at], preload: [:user])
  end

  @doc """
  Gets a single consumption.

  Raises `Ecto.NoResultsError` if the Consumption does not exist.

  ## Examples

      iex> get_consumption!(123)
      %Consumption{}

      iex> get_consumption!(456)
      ** (Ecto.NoResultsError)

  """
  def get_consumption!(id), do: Repo.get!(from(c in Consumption, preload: [:user]), id)

  @doc """
  Creates a consumption.

  ## Examples

      iex> create_consumption(%{field: value})
      {:ok, %Consumption{}}

      iex> create_consumption(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_consumption(user_id, attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :consumption,
      %Consumption{user_id: user_id}
      |> Consumption.changeset(attrs)
    )
    |> Ecto.Multi.update(
      :consumption_with_image,
      &Consumption.image_changeset(&1.consumption, attrs)
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{consumption_with_image: consumption}} -> {:ok, IO.inspect(consumption)}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  def consumption_image_url(%Consumption{image: image} = consumption, version \\ :display) do
    Pintelier.ConsumptionImage.url({image, consumption}, version)
  end

  @doc """
  Updates a consumption.

  ## Examples

      iex> update_consumption(consumption, %{field: new_value})
      {:ok, %Consumption{}}

      iex> update_consumption(consumption, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_consumption(%Consumption{} = consumption, attrs) do
    consumption
    |> Consumption.changeset(attrs)
    |> Consumption.image_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a consumption.

  ## Examples

      iex> delete_consumption(consumption)
      {:ok, %Consumption{}}

      iex> delete_consumption(consumption)
      {:error, %Ecto.Changeset{}}

  """
  def delete_consumption(%Consumption{} = consumption) do
    Consumption.delete_image(consumption)
    Repo.delete(consumption)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking consumption changes.

  ## Examples

      iex> change_consumption(consumption)
      %Ecto.Changeset{data: %Consumption{}}

  """
  def change_consumption(%Consumption{} = consumption, attrs \\ %{}) do
    consumption
    |> Consumption.changeset(attrs)
    |> Consumption.image_changeset(attrs)
  end
end
