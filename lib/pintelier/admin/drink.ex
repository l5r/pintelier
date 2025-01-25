defmodule Pintelier.Admin.Drink do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "drinks" do
    field :abv, :decimal
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(drink, attrs) do
    drink
    |> cast(attrs, [:name, :abv])
    |> validate_required([:name, :abv])
    |> validate_number(:abv, greater_than_or_equal_to: 0)
    |> validate_length(:name, min: 2, max: 255)
  end
end
