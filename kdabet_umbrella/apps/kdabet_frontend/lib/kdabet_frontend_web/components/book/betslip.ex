defmodule KdabetFrontendWeb.Components.BetSlip do
  @moduledoc """
  An HTML module which renders the betslip and manages its display state and interaction with the database.
  """
  use Surface.LiveComponent
  use Surface.Components.Form
  use Surface.Components.Form.{Field, TextInput, Label, Submit}

  @doc "Retrieve and previously pending bets set to betslip"
  prop(prev_pending, :string, required: true)

  @doc "The bet schema changeset"
  data bet, :map, default: %{"beton" => "", "towin" => "", "amount" => ""}

  @doc "The list of the users pending bets"
  data(pending, :string, default: [])

  def render(assigns) do
    ~F"""
    <div class="glassy_modal w-[80%] mx-auto py-5 mt-10">
      <h2 class="border-b border-slate-700 font-bold text-xl indent-5 text-shadow shadow-stone-800 pb-2">Bet Slip</h2>
      <div class="w-[90%] rounded mx-auto mt-5 py-5 text-center text-sm text-stone-800 bg-gradient-to-b from-[rgba(255,255,255,0.6)] to-[rgba(255,255,255,0.8)]">
        {#if @pending |> length == 0}
          <img class="w-[80%] mx-auto" src="images/breeze.png">
          <h3 class="font-bold">You have no pending bets</h3>
          <h3>Please choose a market to wager in</h3>
        {#else}
          <Form class="flex flex-col" for={@bet}>
            {!-- Bet Form --}
            {#for bet <- @pending}
              <div class="flex flex-row justify-between px-3">
                <span class="text-sm font-bold leading-[2.0]">{bet.beton}</span>
                <span class="leading-[2] rounded border-2 border-stone-700 bg-green-500 px-2 text-stone-100 font-bold text-sm">
                  {bet.odd |> String.to_float() |> Decimal.from_float() |> Decimal.round(3) |> Decimal.to_string()}
                </span>
              </div>
              <div class="flex flex-row justify-between px-3 mt-2">
                {!-- Form Fields --}
                <Field name="amount" class="field">
                  <div class="control w-[95%]">
                    <TextInput
                      opts={placeholder: "stake"}
                      name="amount"
                      class="w-full rounded p-1"
                      value={@bet["amount"]}
                    />
                  </div>
                </Field>
                <Field name="towin" class="field">
                  <div class="control w-[95%]">
                    <TextInput
                      opts={placeholder: "to win"}
                      name="towin"
                      class="w-full rounded p-1"
                      value={@bet["towin"]}
                    />
                  </div>
                </Field>
              </div>
              {!-- Form Submit --}
              {#if @pending |> length > 1}
                <hr class="w-[92%] mx-3 border-stone-300 m-2">
              {/if}
            {/for}
            <Submit
              class="w-[90%] rounded font-bold text-lg mt-4 p-2 text-stone-200 mx-auto ring ring-indigo-600 ring-offset-4 bg-sky-300"
              label="Confirm Bets"
            />
          </Form>
        {/if}
      </div>
    </div>
    """
  end

  ## Handle the creation of a new pending bet
  def update_betslip(node_id, odd, beton) do
    send_update(__MODULE__, id: node_id, odd: odd, beton: beton)
  end

  ## Custom Betslip update function
  def update(%{id: "betslip", odd: odd, beton: beton}, socket) do
    IO.inspect(socket.assigns)

    new_assigns =
      assign(socket, %{
        id: "betslip",
        pending: socket.assigns.pending ++ [%{beton: beton, odd: odd}]
      })

    {:ok, new_assigns}
  end

  def update(assigns, socket) do
    IO.inspect(assigns)
    {:ok, socket}
  end
end

## :on-click="tokenslot_click" phx-target={@target} phx-value-index={@index} phx-value-pair={@token}
