defmodule PintelierWeb.ConsumptionLive.FormComponent do
  alias Pintelier.Admin
  use PintelierWeb, :live_component

  alias Pintelier.Drinking

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage consumption records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="consumption-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          :for={vol <- [25, 33, 50]}
          field={@form[:volume_cl]}
          type="setter_button"
          label={"#{vol}cl"}
          target_value={vol}
        />
        <.input field={@form[:volume_cl]} type="number" label="Volume (cl)" list="consumption-sizes" />
        <datalist id="consumption-sizes">
          <option value="25"></option>
          <option value="33"></option>
          <option value="50"></option>
        </datalist>
        <.input
          field={@form[:drink_id]}
          type="select"
          label="Drink"
          prompt="Other"
          options={@drink_options}
        />
        <div :if={is_blank?(@form[:drink_id].value)} class="flex flex-row">
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:abv]} type="number" label="Abv" step="0.1" class="w-10"/>
        </div>
        <:actions>
          <.button phx-disable-with="Saving...">Save Consumption</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{consumption: consumption} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:drink_options, fn ->
       Admin.list_drinks()
       |> Enum.map(&{"#{&1.name} (#{&1.abv}%)", &1.id})
     end)
     |> assign_new(:form, fn ->
       to_form(Drinking.change_consumption(consumption))
     end)}
  end

  @impl true
  def handle_event("validate", %{"consumption" => consumption_params}, socket) do
    changeset = Drinking.change_consumption(socket.assigns.consumption, consumption_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"consumption" => consumption_params}, socket) do
    save_consumption(socket, socket.assigns.action, consumption_params)
  end

  defp save_consumption(socket, :edit, consumption_params) do
    case Drinking.update_consumption(socket.assigns.consumption, consumption_params) do
      {:ok, consumption} ->
        notify_parent({:saved, consumption})

        {:noreply,
         socket
         |> put_flash(:info, "Consumption updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_consumption(socket, :new, consumption_params) do
    user_id = socket.assigns.consumption.user_id

    case Drinking.create_consumption(user_id, consumption_params) do
      {:ok, consumption} ->
        notify_parent({:saved, consumption})

        {:noreply,
         socket
         |> put_flash(:info, "Consumption created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp is_blank?(nil), do: true
  defp is_blank?(val) when val == %{}, do: true
  defp is_blank?(val) when val == [], do: true
  defp is_blank?(val) when is_binary(val), do: String.trim(val) == ""
  defp is_blank?(_), do: false
end
