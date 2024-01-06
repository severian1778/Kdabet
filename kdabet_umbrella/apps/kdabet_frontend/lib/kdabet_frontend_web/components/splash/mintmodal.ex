defmodule KdabetFrontendWeb.Components.MintModal do
  use Surface.LiveComponent

  @doc "The boolean switch to show the nft"
  data(show, :boolean, default: false)

  @doc "The account hash"
  data(account, :string, default: "k:")

  @doc "The wallet Provider"
  data(provider, :string, default: "Ecko")

  slot(default)

  def render(assigns) do
    ~F"""
    <div class={"modal", "!mt-0", "is-active": @show} :on-window-keydown="hide" phx-key="Escape">
      <div class="modal-background" />
      <div class="modal-card">
        <header class="modal-card-head flex flex-row justify-between">
          <p class="modal-card-title">Error: Invalid Wallet</p>
          <button
            :on-click="hide"
            class="rounded-md ring-2 px-2 py-1 ring-stone-800 sans text-xl text-stone-200 bg-sky-600"
          >close</button>
        </header>
    <p class="modal-text">The account: {
      Enum.join([
        @account |> String.slice(0, 10),
        "...",
        @account |> String.reverse() |> String.slice(0, 10) |> String.reverse()
    ])} belonging to the {@provider} network is not whitelisted to mint a Kadena King.<br><br>We apologize for the inconvienice and hope you can acquire one on the open market in 2024.</p>
      </div>
    </div>
    """
  end

  # Public API

  def show(dialog_id, account, provider) do
    send_update(__MODULE__, id: dialog_id, show: true, account: account, provider: provider)
  end

  # Event handlers

  def handle_event("show", _, socket) do
    {:noreply, assign(socket, show: true)}
  end

  def handle_event("hide", _, socket) do
    {:noreply, assign(socket, show: false)}
  end
end
