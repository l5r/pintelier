defmodule PintelierWeb.DrinkLive.FormComponent do
  use PintelierWeb, :live_component

  alias Pintelier.Admin

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage drink records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="drink-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:abv]} type="number" label="ABV (%)" min="0" max="100" step="0.1" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Drink</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{drink: drink} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Admin.change_drink(drink))
     end)}
  end

  @impl true
  def handle_event("validate", %{"drink" => drink_params}, socket) do
    changeset = Admin.change_drink(socket.assigns.drink, drink_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"drink" => drink_params}, socket) do
    save_drink(socket, socket.assigns.action, drink_params)
  end

  defp save_drink(socket, :edit, drink_params) do
    case Admin.update_drink(socket.assigns.drink, drink_params) do
      {:ok, drink} ->
        notify_parent({:saved, drink})

        {:noreply,
         socket
         |> put_flash(:info, "Drink updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_drink(socket, :new, drink_params) do
    case Admin.create_drink(drink_params) do
      {:ok, drink} ->
        notify_parent({:saved, drink})

        {:noreply,
         socket
         |> put_flash(:info, "Drink created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
