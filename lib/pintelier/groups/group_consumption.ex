defmodule Pintelier.Groups.GroupConsumption do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "group_consumptions" do

    field :group, :binary_id
    field :consumption, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group_consumption, attrs) do
    group_consumption
    |> cast(attrs, [])
    |> validate_required([])
  end
end
