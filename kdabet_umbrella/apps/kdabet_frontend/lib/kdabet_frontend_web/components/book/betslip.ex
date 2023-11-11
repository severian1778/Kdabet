defmodule KdabetFrontendWeb.Components.BetSlip do
  @moduledoc """
  An HTML module which renders the betslip and manages its display state and interaction with the database.
  """
  use Surface.LiveComponent
  alias Core.Types.Bet
  use Surface.Components.Form
  use Surface.Components.Form.{Field, TextInput, Submit}

  @doc "Retrieve and previously pending bets set to betslip"
  prop(prev_pending, :list, required: true)

  @doc "The bet schema changeset"
  data(bet, :map, default: %{})

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
            {#for {pending_bet, indice} <- @pending |> Enum.with_index()}
              {!-- Pending Bet Header --}
              <div class="flex flex-row justify-between px-3">
                {!-- matchup info --}
                <div class="flex flex-row justify-start basis-10/12 space-x-2 overflow-hidden">
                  <span class="self-center fill-pink-900 h-4 w-4">
                    <FontAwesome.LiveView.icon name={sporttype_to_fa(pending_bet.sport)} type="solid" /></span>
                  <span class="text-left">{(pending_bet.matchup |> String.slice(0, 32)) <> "..."}</span>
                </div>
                {!-- Close bet clickie --}
                <div class="basis-1/12">
                  <a
                    :on-click="delete_pending"
                    phx-value-index={indice}
                    class="hover:bg-stone-300 hover:text-stone-800 px-2 py-1 rounded"
                    href="#"
                  >X</a>
                </div>
              </div>
              <div class="flex flex-row text-xs px-3 py-1">
                <span>{pending_bet.bettype <> " - " <> pending_bet.bettime <> " - " <> pending_bet.league}</span>
              </div>
              {!-- Pending Bet --}
              <div class="flex flex-row justify-between px-3 my-1">
                <span class="text-sm font-bold leading-[2.0]">{pending_bet.beton}</span>
                <span class="leading-[2] rounded border-2 border-stone-700 bg-green-500 px-2 text-stone-100 font-bold text-sm">
                  {pending_bet.odd
                  |> Decimal.from_float()
                  |> Decimal.round(3)
                  |> Decimal.to_string()}
                </span>
              </div>
              {!-- Pending Bet Form Fields --}
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
              class="w-[90%] rounded font-bold text-lg mt-4 p-2 text-stone-200 mx-auto ring ring-indigo-600 ring-offset-4 bg-sky-300 hover:bg-sky-400"
              label="Confirm Bets"
            />
          </Form>
        {/if}
      </div>
    </div>
    """
  end

  ## Handle the creation of a new pending bet
  @doc """
  Informs the betslip state to update its pending bet list with a new bet
  of type %Core.Types.Bet{}
  """
  @spec update_betslip(String.t(), Bet.t()) :: {atom(), String.t()}
  def update_betslip(node_id, %Bet{} = bet) do
    send_update(__MODULE__, id: node_id, bet: bet)
    {:ok, "Betslip updated"}
  end

  def update_betslip(_node_id, _bet) do
    {:error, "Recieved bad type for betslip"}
  end

  ## Custom Betslip update function
  def update(%{id: "betslip", bet: bet}, socket) do
    new_assigns =
      assign(socket, %{
        id: "betslip",
        pending: socket.assigns.pending ++ [bet]
      })

    {:ok, new_assigns}
  end

  def update(_assigns, socket) do
    {:ok, socket}
  end

  ####################################
  ## Handle Internal BetSlip Events
  ####################################
  @impl true
  def handle_event("delete_pending", %{"index" => indice}, socket) do
    ## pop off the bet from the peding list at the indice chosen
    {_popped, remains} = socket.assigns.pending |> List.pop_at(indice |> String.to_integer())
    {:noreply, assign(socket, id: "betslip", pending: remains)}
  end

  ####################################
  ## End BetSlip Events
  ####################################
  defp sporttype_to_fa(sport) do
    case sport do
      "Baseball" -> "baseball"
      "Basketball" -> "basketball"
      "Hockey" -> "hockey-puck"
      "Soccer" -> "futbol"
      "Football" -> "football"
      "E-Sports" -> "gamepad"
      _ -> "futbol"
    end
  end
end

## :on-click="tokenslot_click" phx-target={@target} phx-value-index={@index} phx-value-pair={@token}
