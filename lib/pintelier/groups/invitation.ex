defmodule Pintelier.Groups.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "group_invitations" do
    field :expiration, :utc_datetime

    belongs_to :group, Pintelier.Groups.Group, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [:expiration, :group_id])
  end
end
