defmodule KdabetFrontendWeb.Kings do
  use KdabetFrontendWeb, :surface_live_view

  alias KdabetFrontendWeb.Components.King

  @impl true
  def mount(_params, _session, socket) do
    ## return the assigns
    pfps = pfplist()

    {:ok,
     socket
     |> assign(id: socket.id)
     |> assign(pfps: pfps)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex flex-col w-full h-fit">
      <!-- Textual information -->
      <section class="sans w-full mx-auto max-w-[1600px] h-fit flex flex-col md:flex-row justify-between py-5 lg:py-10">
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
            <h2 class="px-2 flex flex-row justify-between w-full"><span>Knight Mint Cap:</span><span class="font-bold">200</span></h2>
            <h2 class="px-2 flex flex-row justify-between w-full"><span>Mint Price:</span><span class="font-bold">$300</span></h2>
          </div>
        </div>
        <hr class="w-[85%] mx-auto border-t-slate-700 border-b-slate-600 my-4 block md:hidden">
        <div class="glasscard glowtext sans px-5 lg:px-10 mt-[10px] m-auto md:m-0 w-[400px] min-h-[250px] items-center lg:w-[400px] xl:w-[500px] align-center items-center">
          <h3 class="text-[1.4em] py-2">Benefits</h3>
          <hr class="w-full border-t-slate-700 border-b-slate-600 mb-4">
          <ul class="text-[1.0em] xl:text-[1.3em]">
            <li>~ Hard dividend of all excess profits</li>
            <li>~ 1-1 DAO voting/proposal rights</li>
            <li>~ Affiliate earnings on K:nights NFT</li>
            <li>~ Bonus Perks from corporate partners</li>
            <li>~ Giftable Bet Bonuses</li>
            <li>~ Annual DAO meetup</li>
          </ul>
        </div>
      </section>
      <hr class="w-full border-t-blue-800 border-b-blue-900 mb-5">
      <!-- pfp rows -->
      <section class="w-full flex flex-col mx-auto max-w-[1600px]">
        <div class="glowtext w-full flex flex-row justify-between mb-5">
          <h1 class="text-[1.75em] lg:text-[2.15em] xl:text-[2.7em] flex flex-row font-bold justify-start space-x-1 sm:space-x-2 lg:space-x-3" >
            <span class="h-[40px] w-[40px] lg:h-[50px] lg:w-[50px] xl:h-[60px] xl:w-[60px]"><FontAwesome.LiveView.icon name="scroll" type="solid" class="crownicon" /></span>
            <span>Kings Row</span>
          </h1>
          <p class="glowtext text-[1.75em] lg:text-[2.15em] xl:text-[2.7em]">{(@pfps|>length)}/500</p>
        </div>
        <div class="w-fit flex flex-wrap justify-center">
          <div class="w-[100px] h-[100px]" :for={pfp <- @pfps}>
            <King imageurl={pfp}></King>
          </div>
        </div>
      </section>
    </div>
    """
  end

  defp pfplist() do
    [
      "Lain.png",
      "Frog.png",
      "Theezy.png",
      "Jimmy.png",
      "Junkie.png",
      "Crob.png",
      "Metcalfe.png",
      "BC.png",
      "Fabio.png",
      "nico.png",
      "tmg.png",
      "toshi.png",
      "kennedy.png",
      "pepe.png",
      "pkm.png",
      "hazen.png",
      "kdaminer.png",
      "whitekid.png",
      "rai.png",
      "dab.png",
      "dirty.png",
      "keta.png",
      "glenn.png",
      "Shaun.png",
      "Noah.png",
      "allin.png",
      "lakes.png",
      "jamboy.png",
      "mark.png",
      "mars.png",
      "extrin.png",
      "dodger.png",
      "bored.png",
      "pseno.png",
      "bells.png",
      "olabero.png",
      "up.png",
      "defi.png",
      "snakecat.png",
      "Chantal.png",
      "alex.png",
      "alexander.png",
      "ezal.png",
      "atta.png",
      "marcus.png",
      "mikey.png",
      "kryptonian.png",
      "aryan.png",
      "arrabeelo.png",
      "raf.png",
      "hollywood.png",
      "gonze.png",
      "techfleet.png",
      "sean.png",
      "ireland.png",
      "kadosh.png",
      "emodius.png",
      "sugah.png",
      "mikk.png",
      "carter.png",
      "ciredide.png",
      "arun.png",
      "ivars.png",
      "hobbs.png",
      "rex.png",
      "daya.png",
      "mom.png",
      "kadayee.png",
      "reese.png",
      "silk.png",
      "rich.png",
      "barry.png",
      "problematictia.png",
      "lm99.png",
      "cali.png",
      "pbr.png",
      "collector.png",
      "red.png",
      "greg.png",
      "olofs.png",
      "mahines.png",
      "baller.png",
      "marc.png",
      "haxtral.png",
      "ellis.png",
      "konst.png",
      "defry.png",
      "oneleg.png",
      "uae.png",
      "flexx.png",
      "keeper.png",
      "barb.png",
      "zdero.png",
      "yusuf.png",
      "fractal.png",
      "cryptochris.png",
      "spyder.png",
      "berry.png",
      "alexkda.png",
      "newzealand.png",
      "defiscreens.png",
      "r3.png",
      "debil.png",
      "zotramid.png",
      "eodvet.png",
      "sasa.png",
      "xor.png",
      "baron.png",
      "dicearena.png",
      "baron.png",
      "hankthetank.png",
      "ron.png",
      "janrya.png",
      "warrior.png",
      "retirement.png",
      "newtype.png",
      "phenomenal.png",
      "dopexbt.png",
      "loris.png",
      "prima.png",
      "sniperj.png",
      "borgia.png",
      "raymondreddington.png",
      "yahoo.png",
      "cryptovaulter.png",
      "tonny.png",
      "arctic.png",
      "kenneth.png",
      "happyfaceivy.png",
      "steven.png",
      "rainford.png",
      "rundmc.png",
      "stone.png",
      "aptosboss.png",
      "42.png",
      "sultan.png",
      "rymang.png",
      "zjmloi.png",
      "tippytoe.png",
      "stryker_z_.png",
      "esteban.png",
      "kieonna.png",
      "andrea.png",
      "nikomo.png",
      "kadenadoctor.png",
      "chrissaud.png",
      "nmart.png",
      "sage.png",
      "frankgr.png",
      "erre.png",
      "linesman.png",
      "lookandlikelove.png"
    ]
  end
end
