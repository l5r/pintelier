defmodule Pintelier.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "groups" do
    field :name, :string

    has_many :group_members, Pintelier.Groups.GroupMember
    has_many :invitations, Pintelier.Groups.Invitation

    many_to_many :members, Pintelier.Accounts.User, join_through: "group_members", on_replace: :delete
    many_to_many :consumptions, Pintelier.Drinking.Consumption, join_through: "group_consumptions"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_assoc(:invitations, with: &Pintelier.Groups.Invitation.changeset/2)
    |> cast_assoc(:group_members, with: &Pintelier.Groups.GroupMember.create_changeset/2)
  end
end
