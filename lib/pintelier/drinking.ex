defmodule Pintelier.Drinking do
  @moduledoc """
  The Drinking context.
  """

  import Ecto.Query, warn: false
  alias Pintelier.Drinking
  alias Pintelier.Drinking.ConsumptionSession
  alias Pintelier.Repo

  alias Pintelier.Drinking.Consumption

  @doc """
  Returns the list of consumptions.

  ## Examples

      iex> list_global_consumptions()
      [%Consumption{}, ...]

  """
  def list_global_consumptions do
    Repo.all(from c in Consumption, order_by: [desc: c.inserted_at], preload: [:user])
  end

  def list_user_consumptions(user) do
    Repo.all(
      from c in Consumption,
        where: c.user_id == ^user.id,
        order_by: [desc: c.inserted_at],
        preload: [:user]
    )
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

  def get_user_consumption!(id, user),
    do: Repo.get!(from(c in Consumption, where: c.user_id == ^user.id, preload: [:user]), id)

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
      {:ok, %{consumption_with_image: consumption}} -> update_consumption_session(consumption)
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  defp update_consumption_session(consumption) do
    Ecto.Multi.new()
    |> get_or_create_consumption_session(consumption)
    |> Ecto.Multi.update(
      :consumption,
      &Consumption.session_changeset(
        consumption,
        %{consumption_session_id: &1.consumption_session.id}
      )
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{consumption: consumption}} -> {:ok, consumption}
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  defp get_or_create_consumption_session(multi, consumption) do
    multi
    |> Ecto.Multi.run(:target_session, fn repo, _changes ->
      {:ok,
       repo.one(
         from cs in ConsumptionSession,
           order_by: [desc: :last_consumption],
           limit: 1,
           where: cs.last_consumption > ago(4, "hour") and cs.user_id == ^consumption.user_id
       ) || %ConsumptionSession{user_id: consumption.user_id}}
    end)
    |> Ecto.Multi.insert_or_update(:consumption_session, fn %{target_session: session} ->
      Drinking.ConsumptionSession.changeset(session, %{last_consumption: consumption.inserted_at})
    end)
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
