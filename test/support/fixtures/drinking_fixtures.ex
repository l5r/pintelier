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
end
