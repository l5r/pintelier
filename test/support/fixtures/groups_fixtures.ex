defmodule Pintelier.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pintelier.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Pintelier.Groups.create_group()

    group
  end

  @doc """
  Generate a group_member.
  """
  def group_member_fixture(attrs \\ %{}) do
    {:ok, group_member} =
      attrs
      |> Enum.into(%{
        authorization: :member
      })
      |> Pintelier.Groups.create_group_member()

    group_member
  end

  @doc """
  Generate a invitation.
  """
  def invitation_fixture(attrs \\ %{}) do
    {:ok, invitation} =
      attrs
      |> Enum.into(%{
        expiration: ~U[2025-03-26 22:11:00Z]
      })
      |> Pintelier.Groups.create_invitation()

    invitation
  end

  @doc """
  Generate a group_consumption.
  """
  def group_consumption_fixture(attrs \\ %{}) do
    {:ok, group_consumption} =
      attrs
      |> Enum.into(%{

      })
      |> Pintelier.Groups.create_group_consumption()

    group_consumption
  end
end
