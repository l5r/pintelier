defmodule PintelierWeb.Admin.UserLive do
  alias Pintelier.Accounts.User

  use Backpex.LiveResource,
    adapter_config: [
      schema: User,
      repo: Pintelier.Repo,
      create_changeset: &__MODULE__.create_changeset/3,
      update_changeset: &__MODULE__.update_changeset/3
    ],
    layout: {PintelierWeb.Layouts, :admin},
    pubsub: [
      name: Pintelier.PubSub,
      topic: "users",
      event_prefix: "user_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "User"
  @impl Backpex.LiveResource
  def plural_name, do: "Users"
  @impl Backpex.LiveResource
  def fields do
    [
      name: %{
        module: Backpex.Fields.Text,
        label: "Name"
      },
      email: %{
        module: Backpex.Fields.Text,
        label: "E-Mail"
      },
      is_admin: %{
        module: Backpex.Fields.Boolean,
        label: "Admin"
      },
      confirmed_at: %{
        module: Backpex.Fields.DateTime,
        label: "Confirmed at"
      }
    ]
  end

  def item_actions(default_actions) do
    default_actions ++
      [
        send_confirmation_mail: %{
          module: __MODULE__.SendConfirmationMailAction,
          only: [:row, :index]
        }
      ]
  end

  def create_changeset(user, attrs, _) do
    user
    |> User.registration_changeset(attrs)
    |> User.info_changeset(attrs)
    |> User.admin_changeset(attrs)
  end

  def update_changeset(user, attrs, _) do
    user
    |> User.email_changeset(attrs)
    |> User.info_changeset(attrs)
    |> User.admin_changeset(attrs)
  end

  defmodule SendConfirmationMailAction do
    use BackpexWeb, :item_action
    use PintelierWeb, :verified_routes

    @impl Backpex.ItemAction
    def icon(assigns, _item) do
      ~H"""
      <Backpex.HTML.CoreComponents.icon
        name="hero-envelope"
        class="h-5 w-5 cursor-pointer transition duration-75 hover:scale-110 hover:text-green-600"
      />
      """
    end

    @impl Backpex.ItemAction
    def label(_assigns, _item), do: "Send Confirmation Mail"

    @impl Backpex.ItemAction
    def handle(socket, items, _data) do
      results =
        for user <- items do
          Pintelier.Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )
        end

      socket = case results do
        [{:ok, _}] ->
          socket |> put_flash(:info, "Mail successfully sent")

        [{:err, err}] ->
          socket |> put_flash(:error, "Failed to send mail: #{err}")

        _ ->
          errors = Enum.count(results, &match?({:err, _}, &1))

          if errors > 0 do
            socket |> put_flash(:error, "#{errors} mails failed to send")
          else
            socket |> put_flash(:info, "Mails successfully sent")
          end
      end

      {:ok, socket}
    end
  end
end
