defmodule Pintelier.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pintelier.Admin` context.
  """

  @doc """
  Generate a drink.
  """
  def drink_fixture(attrs \\ %{}) do
    {:ok, drink} =
      attrs
      |> Enum.into(%{
        abv: "120.5",
        name: "some name"
      })
      |> Pintelier.Admin.create_drink()

    drink
  end
end
