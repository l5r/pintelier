defmodule Pintelier.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias Pintelier.Groups.GroupConsumption
  alias Pintelier.Groups.GroupMember
  alias Pintelier.Repo

  alias Pintelier.Groups.Group

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups(user) do
    groups =
      from g in Group,
        join: u in assoc(g, :members),
        where: u.id == ^user.id

    Repo.all(groups)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id) do
    Group
    |> Repo.get!(id)
    |> Repo.preload(group_members: [:user])
  end

  def get_group_with_consumptions!(id) do
    from(g in Group, preload: [consumptions: [:user]])
    |> Repo.get!(id)
  end

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def create_group(attrs, group_members) do
    %Group{group_members: group_members}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  alias Pintelier.Groups.GroupMember

  @doc """
  Returns the list of group_members.

  ## Examples

      iex> list_group_members()
      [%GroupMember{}, ...]

  """
  def list_group_members do
    Repo.all(GroupMember)
  end

  @doc """
  Gets a single group_member.

  Raises `Ecto.NoResultsError` if the Group member does not exist.

  ## Examples

      iex> get_group_member!(123)
      %GroupMember{}

      iex> get_group_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_member!(id), do: Repo.get!(GroupMember, id)

  @doc """
  Creates a group_member.

  ## Examples

      iex> create_group_member(%{field: value})
      {:ok, %GroupMember{}}

      iex> create_group_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_member(attrs \\ %{}) do
    %GroupMember{}
    |> GroupMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_member.

  ## Examples

      iex> update_group_member(group_member, %{field: new_value})
      {:ok, %GroupMember{}}

      iex> update_group_member(group_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_member(%GroupMember{} = group_member, attrs) do
    group_member
    |> GroupMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_member.

  ## Examples

      iex> delete_group_member(group_member)
      {:ok, %GroupMember{}}

      iex> delete_group_member(group_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_member(%GroupMember{} = group_member) do
    Repo.delete(group_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_member changes.

  ## Examples

      iex> change_group_member(group_member)
      %Ecto.Changeset{data: %GroupMember{}}

  """
  def change_group_member(%GroupMember{} = group_member, attrs \\ %{}) do
    GroupMember.changeset(group_member, attrs)
  end

  alias Pintelier.Groups.Invitation

  @doc """
  Returns the list of group_invitations.

  ## Examples

      iex> list_group_invitations()
      [%Invitation{}, ...]

  """
  def list_group_invitations(group) do
    Repo.all(
      from i in Invitation,
        join: g in assoc(i, :group),
        where: g.id == ^group.id
    )
  end

  @doc """
  Gets a single invitation.

  Raises `Ecto.NoResultsError` if the Invitation does not exist.

  ## Examples

      iex> get_invitation!(123)
      %Invitation{}

      iex> get_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invitation!(id) do
    invitations =
      from i in Invitation,
        preload: :group

    Repo.get!(invitations, id)
  end

  @doc """
  Creates a invitation.

  ## Examples

      iex> create_invitation(%{field: value})
      {:ok, %Invitation{}}

      iex> create_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invitation(group, attrs \\ %{}) do
    %Invitation{group_id: group.id}
    |> Invitation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a invitation.

  ## Examples

      iex> delete_invitation(invitation)
      {:ok, %Invitation{}}

      iex> delete_invitation(invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invitation changes.

  ## Examples

      iex> change_invitation(invitation)
      %Ecto.Changeset{data: %Invitation{}}

  """
  def change_invitation(%Invitation{} = invitation, attrs \\ %{}) do
    Invitation.changeset(invitation, attrs)
  end

  def add_user_to_group(user, group) do
    group
    |> Ecto.build_assoc(:group_members, user: user, authorization: :member)
    |> Repo.insert(on_conflict: :nothing)
  end

  def accept_invitation(user, invitation) do
    add_user_to_group(user, invitation.group)
  end

  def update_consumption_groups(consumption, group_ids) do
    group_consumptions =
      Enum.map(group_ids, &%{consumption_id: consumption.id, group_id: &1})

    Repo.insert_all(GroupConsumption, group_consumptions, on_conflict: :nothing)

    Repo.delete_all(
      from gc in GroupConsumption,
        where: gc.consumption_id == ^consumption.id,
        where: gc.group_id not in ^group_ids
    )

    :ok
  end
end
