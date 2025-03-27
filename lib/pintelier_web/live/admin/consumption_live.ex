defmodule PintelierWeb.Admin.ConsumptionLive do
	alias Pintelier.Drinking.Consumption

	use Backpex.LiveResource,
	 adapter_config: [
      schema: Consumption,
      repo: Pintelier.Repo,
      create_changeset: &__MODULE__.create_changeset/3,
      update_changeset: &__MODULE__.update_changeset/3
    ],
    layout: {PintelierWeb.Layouts, :admin},
    pubsub: [
      name: Pintelier.PubSub,
      topic: "consumptions",
      event_prefix: "consumption_"
    ]

  
  @impl Backpex.LiveResource
  def singular_name, do: "Consumption"
  @impl Backpex.LiveResource
  def plural_name, do: "Consumptions"
  @impl Backpex.LiveResource
  def fields do
    [
      inserted_at: %{
        module: Backpex.Fields.DateTime,
        label: "At"
      },
      user: %{
        module: Backpex.Fields.BelongsTo,
        display_field: :name,
        live_resource: PintelierWeb.Admin.UserLive,
        label: "User"
      },
      caption: %{
        module: Backpex.Fields.Text,
        label: "Caption"
      },
      name: %{
        module: Backpex.Fields.Text,
        label: "Name"
      },
      abv: %{
        module: Backpex.Fields.Number,
        label: "Abv (%)"
      },
      volume_cl: %{
        module: Backpex.Fields.Number,
        label: "Volume (cl)"
      }
    ]
  end

  def create_changeset(drink, attrs, _), do: Consumption.changeset(drink, attrs)
  def update_changeset(drink, attrs, _), do: Consumption.changeset(drink, attrs)
end
