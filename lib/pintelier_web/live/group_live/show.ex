defmodule PintelierWeb.GroupLive.Show do
  use PintelierWeb, :live_view
  import PintelierWeb.ConsumptionComponent

  alias Pintelier.Groups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    group =  Groups.get_group_with_consumptions!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, group))
     |> assign(:group, group)
     |> assign(:stats, Groups.get_group_stats!(id))}
  end

  defp page_title(:show, group), do: "Group #{group.name}"
  defp page_title(:edit, _group), do: "Edit Group"
end
