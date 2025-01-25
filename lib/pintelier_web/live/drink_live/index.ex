defmodule PintelierWeb.DrinkLive.Index do
  use PintelierWeb, :live_view

  alias Pintelier.Admin
  alias Pintelier.Admin.Drink

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :drinks, Admin.list_drinks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Drink")
    |> assign(:drink, Admin.get_drink!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Drink")
    |> assign(:drink, %Drink{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Drinks")
    |> assign(:drink, nil)
  end

  @impl true
  def handle_info({PintelierWeb.DrinkLive.FormComponent, {:saved, drink}}, socket) do
    {:noreply, stream_insert(socket, :drinks, drink)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    drink = Admin.get_drink!(id)
    {:ok, _} = Admin.delete_drink(drink)

    {:noreply, stream_delete(socket, :drinks, drink)}
  end
end
