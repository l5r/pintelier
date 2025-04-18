defmodule PintelierWeb.ConsumptionLive.Index do
  alias Pintelier.Groups.GroupConsumption
  alias Pintelier.Groups
  use PintelierWeb, :live_view

  alias Pintelier.Drinking
  alias Pintelier.Drinking.Consumption

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:consumptions, Drinking.list_user_consumptions(socket.assigns.current_user))
      |> assign(:latest_session, Drinking.latest_session(socket.assigns.current_user))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Consumption")
    |> assign(:consumption, Drinking.get_user_consumption!(socket.assigns.current_user, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Consumption")
    |> assign(:consumption, Drinking.new_consumption(socket.assigns.current_user))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Consumptions")
    |> assign(:consumption, nil)
  end

  @impl true
  def handle_info({PintelierWeb.ConsumptionLive.FormComponent, {:saved, consumption}}, socket) do
    {:noreply,
     stream_insert(socket, :consumptions, Pintelier.Repo.preload(consumption, :user), at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    consumption = Drinking.get_consumption!(id)
    {:ok, _} = Drinking.delete_consumption(consumption)

    {:noreply, stream_delete(socket, :consumptions, consumption)}
  end
end
