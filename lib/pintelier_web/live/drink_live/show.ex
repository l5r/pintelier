defmodule PintelierWeb.DrinkLive.Show do
  use PintelierWeb, :live_view

  alias Pintelier.Admin

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:drink, Admin.get_drink!(id))}
  end

  defp page_title(:show), do: "Show Drink"
  defp page_title(:edit), do: "Edit Drink"
end
