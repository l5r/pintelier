defmodule PintelierWeb.ConsumptionComponent do
  use Phoenix.Component

  import PintelierWeb.CoreComponents

  attr :consumption, Pintelier.Drinking.Consumption, required: true
  attr :rest, :global
  def consumption_card(assigns) do
    ~H"""
    <article class="rounded shadow-lg px-2 md:px-6 py-2 md:py-4 border flex-auto" {@rest}>
      <img
        :if={@consumption.image}
        src={Pintelier.Drinking.consumption_image_url(@consumption)}
        class="mb-4 rounded"
      />
      <div class="flex flex-row items-baseline content-between gap-4 mx-3">
        <span class="">
          <span class="font-bold text-xl">{@consumption.user.name}</span>
          &middot;
          <span class="text-sm text-slate-600">
            {@consumption.volume_cl}cl {@consumption.name} ({@consumption.abv}%)
          </span>
        </span>
        <.rel_time time={@consumption.inserted_at} class="self-end ml-auto" />
      </div>
      <p class="mx-3">{@consumption.caption}</p>
    </article>
    """
  end
end
