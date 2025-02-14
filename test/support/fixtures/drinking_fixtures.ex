defmodule Pintelier.DrinkingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pintelier.Drinking` context.
  """

  @doc """
  Generate a consumption.
  """
  def consumption_fixture(attrs \\ %{}) do
    {:ok, consumption} =
      attrs
      |> Enum.into(%{
        abv: "120.5",
        name: "some name",
        volume_cl: 42
      })
      |> Pintelier.Drinking.create_consumption()

    consumption
  end

  @doc """
  Generate a consumption_session.
  """
  def consumption_session_fixture(attrs \\ %{}) do
    {:ok, consumption_session} =
      attrs
      |> Enum.into(%{
        last_consumption: ~U[2025-02-13 17:37:00Z]
      })
      |> Pintelier.Drinking.create_consumption_session()

    consumption_session
  end
end
