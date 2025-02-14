defmodule Pintelier.Drinking.Consumption do
  alias Pintelier.Admin
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "consumptions" do
    field :abv, :decimal
    field :name, :string
    field :volume_cl, :integer

    field :image, Pintelier.ConsumptionImage.Type

    belongs_to :user, Pintelier.Accounts.User, type: :binary_id
    belongs_to :drink, Pintelier.Admin.Drink, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(consumption, attrs) do
    consumption
    |> cast(attrs, [:volume_cl, :drink_id, :name, :abv])
    |> update_drink()
    |> validate_required([:volume_cl, :name, :abv])
    |> foreign_key_constraint(:drink_id)
  end

  def image_changeset(consumption, attrs) do
    consumption
    # TODO: check if there is a way to disallow paths with live uploads
    |> cast_attachments(attrs, [:image], allow_paths: true)
  end

  def delete_image(consumption) do
    if !is_nil(consumption.image) do    	
      :ok = Pintelier.ConsumptionImage.delete({consumption.image, consumption})
    end
  end

  defp update_drink(changeset) do
    if should_update_drink(changeset) do
      drink_id = get_field(changeset, :drink_id)
      drink = Admin.get_drink!(drink_id)

      changeset
      |> change(name: drink.name, abv: drink.abv)
    else
      changeset
    end
  end

  defp should_update_drink(c) do
    (changed?(c, :drink_id) or changed?(c, :name) or changed?(c, :abv))
    and (get_field(c, :drink_id) != nil)
  end
end
