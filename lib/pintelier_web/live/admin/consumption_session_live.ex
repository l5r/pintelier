defmodule PintelierWeb.Admin.ConsumptionSessionLive do
	alias Pintelier.Drinking.ConsumptionSession

	use Backpex.LiveResource,
	 adapter_config: [
      schema: ConsumptionSession,
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
  def singular_name, do: "Consumption Session"
  @impl Backpex.LiveResource
  def plural_name, do: "Consumption Sessions"
  @impl Backpex.LiveResource
  def fields do
    [
      user: %{
        module: Backpex.Fields.BelongsTo,
        display_field: :name,
        live_resource: PintelierWeb.Admin.UserLive,
        label: "User"
      },
      inserted_at: %{
        module: Backpex.Fields.DateTime,
        label: "Start"
      },
      last_consumption: %{
        module: Backpex.Fields.DateTime,
        label: "End"
      },
    ]
  end

  def create_changeset(drink, attrs, _), do: ConsumptionSession.changeset(drink, attrs)
  def update_changeset(drink, attrs, _), do: ConsumptionSession.changeset(drink, attrs)
end
