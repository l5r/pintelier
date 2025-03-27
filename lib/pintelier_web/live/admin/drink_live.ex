defmodule PintelierWeb.Admin.DrinkLive do
  alias Pintelier.Admin.Drink

  use Backpex.LiveResource,
    adapter_config: [
      schema: Drink,
      repo: Pintelier.Repo,
      create_changeset: &__MODULE__.create_changeset/3,
      update_changeset: &__MODULE__.update_changeset/3
    ],
    layout: {PintelierWeb.Layouts, :admin},
    pubsub: [
      name: Pintelier.PubSub,
      topic: "drinks",
      event_prefix: "drink_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Drink"
  @impl Backpex.LiveResource
  def plural_name, do: "Drinks"
  @impl Backpex.LiveResource
  def fields do
    [
      name: %{
        module: Backpex.Fields.Text,
        label: "Name"
      },
      abv: %{
        module: Backpex.Fields.Number,
        label: "Abv (%)"
      }
    ]
  end

  def create_changeset(drink, attrs, _), do: Drink.changeset(drink, attrs)
  def update_changeset(drink, attrs, _), do: Drink.changeset(drink, attrs)
end
