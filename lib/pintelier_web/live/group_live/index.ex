defmodule PintelierWeb.GroupLive.Index do
  alias Pintelier.Groups.GroupMember
  use PintelierWeb, :live_view

  alias Pintelier.Groups
  alias Pintelier.Groups.Group

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :groups, Groups.list_groups(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    group = Groups.get_group!(id)

    if Groups.can_edit_group?(socket.assigns.current_user, group) do
      socket
      |> assign(:page_title, "Edit Group")
      |> assign(:group, Groups.get_group!(id))
    else
      socket
      |> put_flash(:error, "Unauthorized")
      # Redirect because it shouldn't be possible to get here without client manipulation
      |> redirect(to: ~p"/groups")
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group")
    |> assign(:group, %Group{
      members: [
        socket.assigns.current_user
      ],
      group_members: [
        %GroupMember{user: socket.assigns.current_user, authorization: :admin}
      ]
    })
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Groups")
    |> assign(:group, nil)
  end

  @impl true
  def handle_info({PintelierWeb.GroupLive.FormComponent, {:saved, group}}, socket) do
    {:noreply, stream_insert(socket, :groups, group)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group = Groups.get_group!(id)
    if Groups.can_delete_group?(socket.assigns.current_user, group) do
      {:ok, _} = Groups.delete_group(group)
      {:noreply, stream_delete(socket, :groups, group)}
    else
      socket
      |> put_flash(:error, "Unauthorized")
      |> redirect(to: "~p/groups")
    end
  end
end
