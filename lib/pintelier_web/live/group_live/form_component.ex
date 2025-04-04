defmodule PintelierWeb.GroupLive.FormComponent do
  use PintelierWeb, :live_component

  alias Pintelier.Groups

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage groups.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="group-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Group</.button>
        </:actions>
      </.simple_form>

      <div :if={@group.id} class="mt-11">
        <.button :if={@group.id} phx-click="generate_invite" phx-target={@myself}>Create invite link</.button>
        <code :if={@invite_link} class="block rounded-lg py-2 px-3 mt-2 leading-6 bg-gray-200 border border-zinc-300">
          {@invite_link}
        </code>
      </div>

      <h2 class="mt-11 text-lg font-semibold leading-8 text-zinc-800">Members</h2>
      <.table rows={@form[:group_members].value} id="members">
        <:col :let={member} label="Name">{member.user.name}</:col>
        <:col :let={member} label="Authorization">{member.authorization}</:col>
      </.table>
    </div>
    """
  end

  @impl true
  def update(%{group: group} = assigns, socket) do
    IO.inspect(socket.assigns, label: :update)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:invite_link, fn -> nil end)
     |> assign_new(:form, fn ->
       to_form(Groups.change_group(group))
     end)}
  end

  @impl true
  def handle_event("validate", %{"group" => group_params}, socket) do
    changeset = Groups.change_group(socket.assigns.group, group_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"group" => group_params}, socket) do
    save_group(socket, socket.assigns.action, group_params)
  end

  def handle_event("generate_invite", _params, socket) do
    params = %{expiration: Timex.now() |> Timex.add(Timex.Duration.from_days(30)) }
  	{:ok, new_invite} = Groups.create_invitation(socket.assigns.group, params)
  	{:noreply, assign(socket, invite_link: url(~p"/invitations/#{new_invite}"))}
  end

  defp save_group(socket, :edit, group_params) do
    case Groups.update_group(socket.assigns.group, group_params) do
      {:ok, group} ->
        notify_parent({:saved, group})

        {:noreply,
         socket
         |> put_flash(:info, "Group updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_group(socket, :new, group_params) do
    case Groups.create_group(group_params, socket.assigns.group.group_members) do
      {:ok, group} ->
        notify_parent({:saved, group})

        {:noreply,
         socket
         |> put_flash(:info, "Group created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp member_options(field) do
    members = field.value

    result =
      for member <- members do
        [key: member.name, value: member.id, selected: true]
      end

    result
  end
end
