defmodule KdabetFrontendWeb.Kings do
  use KdabetFrontendWeb, :surface_live_view

  alias KdabetFrontendWeb.Kings
  alias KdabetFrontendWeb.Components.{King, KingModal}
  alias KdabetFrontend.Kings

  @impl true
  def mount(_params, _session, socket) do
    ## return the assigns
    kings = Kings.get_kings()
    lords = lordslist()

    mint_status = Kings.get_state() |> Map.get(:minted)

    {:ok,
     socket
     |> assign(id: socket.id)
     |> assign(kings: kings)
     |> assign(lords: lords)
     |> assign(minted: mint_status)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex flex-col w-full h-fit">
      <!-- Modal Popup -->
      <KingModal id="modal" />

      <!-- Textual information -->
      <section class="font-exo2 w-full mx-auto max-w-[1600px] h-fit flex flex-col md:flex-row justify-between py-5 lg:py-10">
        <div class="glowtext flex justify-between flex-col md:justify-start w-full md:w-1/2">
          <div class="w-full">
            <h1 class="text-[1.75em] lg:text-[2.15em] xl:text-[2.7em] flex flex-row font-bold justify-center md:justify-start space-x-1 sm:space-x-2 lg:space-x-3">
              <span class="h-[40px] w-[40px] lg:h-[50px] lg:w-[50px] xl:h-[60px] xl:w-[60px]"><FontAwesome.LiveView.icon name="crown" type="solid" class="crownicon" /></span>
              <span>The Kadena King NFT</span>
            </h1>
            <h2 class="text-[1.25em] lg:text-[1.5em] px-2 my-3 text-center md:text-left mx-auto md:mx-0 w-[85%] md:w-full">A Utility NFT granting equal share management of the KDAbet betting smart contract via KDAbet DAO</h2>
          </div>
          <hr class="w-[85%] mx-auto border-t-slate-700 border-b-slate-600 my-4 block md:hidden">
          <div class="py-3 m-auto md:m-0 text-[1.75em] w-[320px]">
            <h2 class="px-2 flex flex-row justify-between w-full"><span>Hard Cap:</span><span class="font-bold">500</span></h2>
            <h2 class="px-2 flex flex-row justify-between w-full"><span>Knight Mint Cap:</span><span class="font-bold">100</span></h2>
            <h2 class="px-2 flex flex-row justify-between w-full"><span>Mint Price:</span><span class="font-bold">$300</span></h2>
          </div>
        </div>
        <hr class="w-[85%] mx-auto border-t-slate-700 border-b-slate-600 my-4 block md:hidden">
        <div class="glasscard glowtext font-exo-2 px-5 lg:px-10 mt-[10px] m-auto md:m-0 w-[340px] md:w-[360px] sm:w-[400px] min-h-[250px] items-center lg:w-[400px] xl:w-[500px] align-center items-center">
          <h3 class="text-[1.6em] py-2 font-bold">Benefits</h3>
          <hr class="w-full border-t-slate-700 border-b-slate-600 mb-3">
          <ul class="text-[1.1em] xl:text-[1.4em]">
            <li>~ Hard dividend of all excess profits</li>
            <li>~ 1-1 DAO voting/proposal rights</li>
            <li>~ Affiliate earnings on K:nights NFT</li>
            <li>~ Bonus Perks from partners</li>
            <li>~ Giftable Bet Bonuses</li>
            <li>~ Annual DAO meetup</li>
          </ul>
        </div>
      </section>
      <hr class="w-full border-t-blue-800 border-b-blue-900 mb-5">
      <!-- nft rows -->
      <section class="font-exo2 w-full flex flex-col mx-auto max-w-[1600px]">
        <!-- Kings Section -->
        <div class="glowtext w-full flex flex-col sm:flex-row justify-between text-center sm:text-left">
          <h1 class="w-full sm:w-[50%] text-[1.75em] lg:text-[2.15em] xl:text-[2.7em] flex flex-row font-bold justify-center sm:justify-start space-x-1 sm:space-x-2 lg:space-x-3">
            <span class="h-[40px] w-[40px] lg:h-[50px] lg:w-[50px] xl:h-[60px] xl:w-[60px]"><FontAwesome.LiveView.icon name="scroll" type="solid" class="crownicon" /></span>
            <span>Kings Collection</span>
            <span class="block sm:hidden h-[40px] w-[40px] lg:h-[50px] lg:w-[50px] xl:h-[60px] xl:w-[60px]"><FontAwesome.LiveView.icon name="scroll" type="solid" class="crownicon" /></span>
          </h1>

          <p class="glowtext w-full sm:w-auto text-[1.75em] lg:text-[2.15em] xl:text-[2.7em]">{@kings |> length}/453 Minted</p>
        </div>

        <!-- Seperator -->
        <hr class="border-stone-700 my-4">

        <!-- Kings Collection List -->
        <div class="kingcontainer flex flex-wrap justify-center">
          <!-- Iterate through the kings -->
          <div
            class="w-full lg:mb-5 lg:w-[50%] my-2 sm:max-w-xl lg:max-w-md xl:max-w-xl 2xl:max-w-2xl mx-auto"
            :for={{{_address, discord, name, _has_minted, _ipfs}, index} <- @kings |> Enum.with_index()}
          >
            <King name={name} discord={discord} minted={@minted |> Enum.at(index)} />
          </div>
        </div>
        <!-- Lords Section -->
        <div class="glowtext w-full flex flex-row justify-between">
          <h1 class="text-[1.75em] lg:text-[2.15em] xl:text-[2.7em] flex flex-row font-bold justify-start space-x-1 sm:space-x-2 lg:space-x-3">
            <span class="h-[40px] w-[40px] lg:h-[50px] lg:w-[50px] xl:h-[60px] xl:w-[60px]"><FontAwesome.LiveView.icon name="scroll" type="solid" class="crownicon" /></span>
            <span>Lords Row</span>
          </h1>
          <p class="glowtext text-[1.75em] lg:text-[2.15em] xl:text-[2.7em]">{@lords |> length}/46</p>
        </div>
        <!-- Seperator -->
        <hr class="border-stone-700 my-4">

        <!-- Kings Collection List -->
        <div class="kingcontainer flex flex-wrap justify-center">
          <h1 class="sans glowtext text-[3rem] text-center py-5">To Be Announced</h1>
        </div>
      </section>
    </div>

    <script type="text/javascript">
      const container = document.querySelector('.kingcontainer')

      container.addEventListener('mousemove', ev => {
        const target = ev.srcElement.nextElementSibling
        var x = ev.clientX;
        var y = ev.clientY;
        target.style.top = (y+10)+"px";
        target.style.left = (x+10)+"px";
      })
    </script>
    """
  end

  @impl true
  def handle_event("show_modal", %{"uri" => uri, "name" => name}, socket) do
    KingModal.show("modal", uri, name)
    {:noreply, socket}
  end
end
