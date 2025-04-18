defmodule PintelierWeb.Admin.GroupLive do
  alias Pintelier.Groups.Group

  use Backpex.LiveResource,
    adapter_config: [
      schema: Group,
      repo: Pintelier.Repo,
      create_changeset: &__MODULE__.create_changeset/3,
      update_changeset: &__MODULE__.update_changeset/3
    ],
    layout: {PintelierWeb.Layouts, :admin},
    pubsub: [
      name: Pintelier.PubSub,
      topic: "groups",
      event_prefix: "group_"
    ]

  @impl Backpex.LiveResource
  def singular_name(), do: "Group"
  @impl Backpex.LiveResource
  def plural_name(), do: "Groups"

  @impl Backpex.LiveResource
  def fields do
    [
      inserted_at: %{
        module: Backpex.Fields.DateTime,
        label: "Inserted at",
        only: ~w{show index}a
      },
      name: %{
        module: Backpex.Fields.Text,
        label: "Name"
      },
      members: %{
        module: Backpex.Fields.HasMany,
        label: "Members",
        display_field: :name,
        display_field_form: :name,
        live_resource: PintelierWeb.Admin.UserLive
      }
    ]
  end

  def create_changeset(group, attrs, _), do: Group.changeset(group, attrs)
  def update_changeset(group, attrs, _), do: Group.changeset(group, attrs)
end
