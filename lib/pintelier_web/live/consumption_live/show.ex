defmodule PintelierWeb.ConsumptionLive.Show do
  use PintelierWeb, :live_view

  alias Pintelier.Drinking

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:consumption, Drinking.get_consumption!(id))}
  end

  defp page_title(:show), do: "Show Consumption"
  defp page_title(:edit), do: "Edit Consumption"
end
