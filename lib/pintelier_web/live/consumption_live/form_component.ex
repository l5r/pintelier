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
        <div :if={is_blank?(@form[:drink_id].value)} class="flex flex-row gap-2">
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:abv]} type="number" label="Abv" step="0.1" class="w-10" />
        </div>

        <div class="bg-gray-100 p-4 rounded-lg" phx-drop-target={@uploads.image.ref}>
          <label
            for={@uploads.image.ref}
            class="rounded-lg bg-blue-900 hover:bg-blue-700 p-3 text-sm font-semibold leading-6 text-white cursor-pointer block w-fit"
          >
            <.live_file_input upload={@uploads.image} capture="user" class="hidden" />
            <.icon name="hero-photo-solid" class="align-bottom me-1" />Add Image
          </label>

          <article
            :for={entry <- @uploads.image.entries}
            class="rounded border w-fit mt-4 px-4 py-2 flex flex-col items-center gap-2 bg-blue-100"
          >
            <figure>
              <.live_img_preview entry={entry} class="max-w-32 max-h-32" />
            </figure>

            <div class="flex rounded border border-gray-300 divide-x divide-gray-300">
              <%!-- entry.progress will update automatically for in-flight entries --%>
              <progress value={entry.progress} max="100" class="rounded-s">{entry.progress}%</progress>

              <%!-- a regular click event whose handler will invoke Phoenix.LiveView.cancel_upload/3 --%>
              <button
                class="bg-red-700 rounded-e"
                type="button"
                phx-click="cancel-upload"
                phx-target={@myself}
                phx-value-ref={entry.ref}
                aria-label="cancel"
              >
                <.icon name="hero-x-mark" class="text-white"/>
              </button>
            </div>

            <%!-- Phoenix.Component.upload_errors/2 returns a list of error atoms --%>
            <.error :for={err <- upload_errors(@uploads.image, entry)}>
              {translate_error(err)}
            </.error>
          </article>
        </div>

        <.input
          field={@form[:caption]}
          type="text"
          label="Caption"
        />

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
     end)
     |> assign_new(:uploaded_files, fn -> [] end)
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png .webp))}
  end

  @impl true
  def handle_event("validate", %{"consumption" => consumption_params}, socket) do
    changeset = Drinking.change_consumption(socket.assigns.consumption, consumption_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"consumption" => consumption_params}, socket) do
    uploaded_paths =
      consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
        path_with_extension = path <> "." <> List.first(MIME.extensions(entry.client_type), "bin")
        File.rename!(path, path_with_extension)
        {:ok, path_with_extension}
      end)

    consumption_params =
      case uploaded_paths do
        [] -> consumption_params
        [uploaded_path] -> Map.put(consumption_params, "image", uploaded_path)
      end

    save_consumption(socket, socket.assigns.action, consumption_params)
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp save_consumption(socket, :edit, consumption_params) do
    save_result =
      if socket.assigns.consumption.id do
        Drinking.update_consumption(socket.assigns.consumption, consumption_params)
      else
        Drinking.create_consumption(socket.assigns.consumption, consumption_params)
      end

    case save_result do
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
