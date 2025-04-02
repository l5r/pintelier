defmodule Pintelier.Groups.GroupMember do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "group_members" do
    field :authorization, Ecto.Enum, values: [:member, :admin]

    belongs_to :group, Pintelier.Groups.Group, type: :binary_id
    belongs_to :user, Pintelier.Accounts.User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [:group_id, :user_id, :authorization])
    |> update_change(:authorization, &(&1 || :member))
    |> unsafe_validate_unique([:group_id, :user_id], Pintelier.Repo)
    |> foreign_key_constraint(:goup_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:group_id, :user_id])
  end

  def edit_changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [:authorization])
    |> validate_required([:authorization])
  end
end
