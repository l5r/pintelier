defmodule PintelierWeb.ConsumptionLive.Index do
  use PintelierWeb, :live_view

  alias Pintelier.Drinking
  alias Pintelier.Drinking.Consumption

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :consumptions, Drinking.list_consumptions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Consumption")
    |> assign(:consumption, Drinking.get_consumption!(id))
  end

  defp apply_action(socket, :new, _params) do
    user_id = socket.assigns.current_user.id
    socket
    |> assign(:page_title, "New Consumption")
    |> assign(:consumption, %Consumption{user_id: user_id, drink: nil})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Consumptions")
    |> assign(:consumption, nil)
  end

  @impl true
  def handle_info({PintelierWeb.ConsumptionLive.FormComponent, {:saved, consumption}}, socket) do
    {:noreply, stream_insert(socket, :consumptions, Pintelier.Repo.preload(consumption, :user))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    consumption = Drinking.get_consumption!(id)
    {:ok, _} = Drinking.delete_consumption(consumption)

    {:noreply, stream_delete(socket, :consumptions, consumption)}
  end
end
