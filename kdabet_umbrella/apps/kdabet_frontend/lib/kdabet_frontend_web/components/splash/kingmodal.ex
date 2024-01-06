defmodule KdabetFrontendWeb.Components.KingModal do
  use Surface.LiveComponent

  @doc "the boolean switch to show the nft"
  data(show, :boolean, default: false)

  @doc "the boolean switch to show the nft"
  data(name, :boolean, default: "King")

  @doc "the uri of the modal image"
  data(uri, :string, default: "stephen")

  slot(default)

  def render(assigns) do
    ~F"""
    <div class={"modal", "is-active": @show} :on-window-keydown="hide" phx-key="Escape">
      <div class="modal-background" />
      <div class="modal-card">
        <header class="modal-card-head flex flex-row justify-between">
          <p class="modal-card-title">{@name}</p>
          <button
            :on-click="hide"
            class="rounded-md ring-2 px-2 py-1 ring-stone-800 sans text-xl text-stone-200 bg-sky-600"
          >close</button>
        </header>
        <img class="w-full" src={"/images/kings/" <> @uri <> ".png"}>
      </div>
    </div>
    """
  end

  # Public API

  def show(dialog_id, uri, name) do
    send_update(__MODULE__, id: dialog_id, show: true, uri: uri, name: name)
  end

  # Event handlers

  def handle_event("show", _, socket) do
    {:noreply, assign(socket, show: true)}
  end

  def handle_event("hide", _, socket) do
    {:noreply, assign(socket, show: false)}
  end
end
