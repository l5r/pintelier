defmodule PintelierWeb.FeedLive.Index do
  use PintelierWeb, :live_view
  import PintelierWeb.ConsumptionComponent

  alias Pintelier.Drinking
  alias Pintelier.Drinking.Consumption

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    if current_user do
      {:ok, stream(socket, :consumptions, Drinking.list_feed_consumptions(current_user))}
    else
      {:ok, stream(socket, :consumptions, Drinking.list_global_consumptions())}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Feed")
    |> assign(:consumption, nil)
  end

  defp apply_action(socket, :new, _params) do
    if socket.assigns.current_user do
      socket
      |> assign(:page_title, "New Consumption")
      |> assign(:consumption, Drinking.new_consumption(socket.assigns.current_user))
    else
      socket
      |> put_flash(:info, "You need to have an account to use this button.")
      |> redirect(to: ~p"/users/log_in")
    end
  end

  @impl true
  def handle_info({PintelierWeb.ConsumptionLive.FormComponent, {:saved, consumption}}, socket) do
    {:noreply,
     stream_insert(socket, :consumptions, Pintelier.Repo.preload(consumption, :user), at: 0)}
  end
end
