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
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:group, Groups.get_group_with_consumptions!(id))}
  end

  defp page_title(:show), do: "Show Group"
  defp page_title(:edit), do: "Edit Group"
end
