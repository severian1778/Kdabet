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
        <div class="kingcontainer w-fit flex flex-wrap justify-center">
          <div class="w-[100px] h-[100px] shadow-[inset_0_-2px_4px_rgba(0,0,0,0.6)]" :for={ {pfp, twitter} <- @pfps}>
            <King imageurl={pfp} twitter={twitter}></King>
          </div>
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

  defp pfplist() do
    [
      {"Lain.png", "cryptocyberia"},
      {"Frog.png", "thatpeskyfrog"},
      {"Theezy.png", "theezy350"},
      {"Jimmy.png", "JimmieDoss"},
      {"Junkie.png", "KryptoJunkeez"},
      {"Crob.png", "cnrob1985"},
      {"Metcalfe.png", "laye1hunter"},
      {"BC.png", "KadenaBC"},
      {"keyes.png", "KeyesLD"},
      {"Fabio.png", "FabioBardho2"},
      {"nico.png", "MyranNicolas"},
      {"tmg.png", "tmg20gmt"},
      {"toshi.png", "Kadtoshi"},
      {"kennedy.png", "Mr_Kennedy_123"},
      {"pepe.png", "hodl_pepe"},
      {"mikael.png", "M1kewesterling"},
      {"pkm.png", "butterbean128"},
      {"hazen.png", "hazennik"},
      {"kdaminer.png", "KDAminer"},
      {"whitekid.png", "whitekidcrypto"},
      {"rai.png", "RaiSM129"},
      {"dab.png", "thedabatola"},
      {"dirty.png", "dirty_du"},
      {"keta.png", "thekadenamine"},
      {"glenn.png", "HodlGlenn"},
      {"Shaun.png", "ShaunW3333333"},
      {"Noah.png", "NoahKDA"},
      {"allin.png", "KadenaMee"},
      {"lakes.png", "TheLakesDev"},
      {"jamboy.png", "JamboyCrypto"},
      {"mark.png", "CliffyMark"},
      {"mars.png", "teensfrommarz"},
      {"extrin.png", "Extrinsiic"},
      {"dodger.png", "Rich_Davis_"},
      {"bored.png", "BoredInDaOffice"},
      {"pseno.png", "kpseno"},
      {"bells.png", "tolling_bells"},
      {"olabero.png", "olabero"},
      {"up.png", "POW_Mooon"},
      {"defry.png", "K_DefiRy"},
      {"defi.png", "KadenaDEFI"},
      {"snakecat.png", "James50818951"},
      {"Chantal.png", "ChantalBarnes15"},
      {"kurator.png", "CurtisCaudill3"},
      {"alex.png", "idkfaiddqdll"},
      {"alexander.png", "DodgyMadGeezer7"},
      {"ezal.png", "ezal_kda"},
      {"atta.png", "Jack__atta"},
      {"marcus.png", "TheMarcus"},
      {"mikey.png", "AraujoMDS"},
      {"kryptonian.png", "BTC_RedPhone"},
      {"aryan.png", "vimalion"},
      {"arrabeelo.png", "hu45430"},
      {"raf.png", "rafuael"},
      {"hollywood.png", "hollywood__25"},
      {"gonze.png", "LeGonze14"},
      {"techfleet.png", "TechFleetWorks"},
      {"sean.png", "ufosrule"},
      {"ireland.png", "kadena_ireland"},
      {"kadosh.png", "Kadoshmma"},
      {"lola.png", "Lolaelsa3"},
      {"emodius.png", "Toga_inu"},
      {"sugah.png", "sugarkad01"},
      {"mikk.png", "MikkSilk"},
      {"carter.png", "Jakec2570"},
      {"ciredide.png", "ciradide"},
      {"arun.png", "Arunroohaayil"},
      {"ivars.png", "Ivarss87"},
      {"hobbs.png", "BryanHo71528448"},
      {"rex.png", "TRex91576504"},
      {"daya.png", "DayaKri70181149"},
      {"mom.png", "MomDevi250752"},
      {"kadayee.png", "kenkdab"},
      {"reese.png", "Shaney_Mac"},
      {"silk.png", "silkaitis69"},
      {"rich.png", "shaboomi"},
      {"barry.png", "ChristopherBarw"},
      {"problematictia.png", "ProblematicTia"},
      {"lm99.png", "realLouisM"},
      {"cali.png", "KadenaCali"},
      {"pbr.png", "pbr713"},
      {"collector.png", "sjhjetty"},
      {"greg.png", "CryptoGreg12"},
      {"olofs.png", "johnolofs"},
      {"mahines.png", "MaH1nes"},
      {"baller.png", "DanteSettles"},
      {"marc.png", "marc815"},
      {"haxtral.png", "haxtral"},
      {"ellis.png", "DanEllis1984"},
      {"konst.png", "koski_kostas"},
      {"oneleg.png", "OneLeggedDave"},
      {"uae.png", "KadenaUae"},
      {"flexx.png", "FUDMasterFlex10"},
      {"keeper.png", "foxdie47"},
      {"barb.png", "BarbaricPuma"},
      {"zdero.png", "KDAmakemerich"},
      {"yusuf.png", "ysfcy"},
      {"fractal.png", "PoW_Maxi_"},
      {"cryptochris.png", "cryptochris745"},
      {"spyder.png", "TheCryptoSpyder"},
      {"berry.png", "MoleyBoy"},
      {"alexkda.png", "BelieveInKDA"},
      {"newzealand.png", "CryptoVibeNZ"},
      {"defiscreens.png", "DeFifutures"},
      {"r3.png", "r3hatar"},
      {"debil.png", "debilisatore"},
      {"zotramid.png", "Zotramid"},
      {"eodvet.png", "EodVet98"},
      {"sasa.png", "sanna_sa1976"},
      {"xor.png", "devkaptain"},
      {"dicearena.png", "DiceArena"},
      {"baron.png", "BaronRon10"},
      {"hankthetank.png", "Hank_Cjr"},
      {"ron.png", "ron_kda"},
      {"janrya.png", "Janrya"},
      {"warrior.png", "KDAVRArmy"},
      {"retirement.png", "pduivenb"},
      {"newtype.png", "digicryptJC"},
      {"phenomenal.png", "PhenomenalM4"},
      {"dopexbt.png", "dopeXBT"},
      {"loris.png", "pepespidy"},
      {"prima.png", "kaustraliaUO"},
      {"sniperj.png", "jotopia_fl"},
      {"borgia.png", "BorgiaBorgiabig"},
      {"raymondreddington.png", "RedXRaymond"},
      {"yahoo.png", "Yahoooo_KDA"},
      {"cryptovaulter.png", "karolp173"},
      {"tonny.png", "TonnyAjija"},
      {"arctic.png", "Abner369Ureil"},
      {"kenneth.png", "miix3_"},
      {"happyfaceivy.png", "happyfaceivy"},
      {"steven.png", "ReiFriend"},
      {"rainford.png", "RainfordLennon"},
      {"rundmc.png", "dm_c89"},
      {"stone.png", "Ziraydion"},
      {"aptosboss.png", "aptosboss"},
      {"42.png", "tdorjey101"},
      {"sultan.png", "BarokahSultan"},
      {"rymang.png", "Rynocerosaurus"},
      {"zjmloi.png", "zjmloi"},
      {"tippytoe.png", "tippyto10383856"},
      {"stryker_z_.png", "stryker_Z_"},
      {"esteban.png", "juanes2512"},
      {"kieonna.png", "muzzle1996"},
      {"andrea.png", "uhgvbfp44eysvxq"},
      {"nikomo.png", "niko001mo"},
      {"kadenadoctor.png", "BonNepoleon"},
      {"chrissaud.png", "Nou_alsaud1"},
      {"nmart.png", "05686Jumu"},
      {"sage.png", "DarwinsDaze"},
      {"frankgr.png", "Fragkis75824766"},
      {"erre.png", "Trendy500"},
      {"linesman.png", "LinesmanX"},
      {"lookandlikelove.png", "looknlikelove"},
      {"amir.png", "amirdapl"},
      {"asymmetrical.png", "sirikhalsa5"},
      {"uk.png", "KadenaUK"},
      {"elle.png", "Yungshelly"},
      {"j7.png", "1joemallette"},
      {"elena.png", "ElenaUsss"},
      {"g7.png", "G7crypto"},
      {"joshingram.png", "josh_Ingram"},
      {"northwestern.png", "rotehl"},
      {"arlo.png", "ArloGibb"},
      {"nehire.png", "Nehire18890016"},
      {"goodman.png", "GoodBracho"},
      {"nik.png", "borssen"},
      {"fiero.png", "ferdechill"},
      {"alaatrash.png", "Alatrash17Alaa"},
      {"sergio.png", "WorldKadena"},
      {"kimberlee.png", "kimdavis619"},
      {"nikola.png", "NikolaSong"},
      {"kylemarek.png", "KyleMarek7"},
      {"ace.png", "NotAcee1x"},
      {"loretta.png", "1ofadozenlotta"},
      {"maasai.png", "CryptoManLasse"},
      {"azzacalabaza.png", "azzacalabaza"},
      {"thomasyasmin.png", "Yasmin11D"},
      {"thomasrehab.png", "rehab_fa_"},
      {"01way.png", "01_Drue"},
      {"cenghizgan.png", "cengizhankavas"},
      {"supersaucy.png", "SuperSaucy_KDA"},
      {"kjordan.png", "K_Jordanian"},
      {"kevinclark.png", "C4Cryptos"},
      {"kadeniak.png", "Kadeniak"},
      {"imback.png", "NepoleonBon"},
      {"world.png", "WorldKadena"},
      {"mcrib.png", "adoromanteiga"},
      {"pineapple.png", "PineappleAura"},
      {"mavstar.png", "DJmavstar"},
      {"bertrand.png", "bertrand_web3"},
      {"jarlsven.png", "TheUnrealSven"},
      {"orbine.png", "Orbine3"},
      {"william.png", "JamestownWX"},
      {"ronlaflamme.png", "RonLaFlammeEsq"},
      {"paulb.png", "paulb360"},
      {"eddenhaz.png", "eddenhazz"},
      {"bradkendrick.png", "BradKendrick7"},
      {"tom.png", "tom89sh"},
      {"casual.png", "CasualMining"},
      {"anolik.png", "anolik.png"},
      {"marian.png", "marianKDA84"},
      {"spaceman.png", "C_SpaceMan39"},
      {"redacted.png", "a_a_redacted"},
      {"james.png", "bettingncrypto"},
      {"123.png", "SonyaMa86082489"},
      {"cheese.png", "MCheesington"},
      {"wolf.png", "MauiMiners"},
      {"udderly.png", "UdderlyNFTs"},
      {"joshua.png", "joshuahade"},
      {"raechel.png", "CowellClass"},
      {"ogoy.png", "markyboy8284"},
      {"leandro.png", "Leandrokol"},
      {"santana.png", "KaGeRT90"},
      {"marvi.png", "MarviSofi48197"},
      {"neuromancer.png", "neuromancer_t"},
      {"edd.png", "Eddk147"},
      {"hobbit.png", "K_Noigiallach"},
      {"walter.png", "LCX_PRINCE"},
      {"nemrah.png", "CryptoNemrah"},
      {"krr.png", "B028302830V"},
      {"joeleo.png", "Joeleo_13"},
      {"trias.png", "trias_gom"},
      {"madness.png", "gracie915"},
      {"mayoyo.png", "MayoyoCrypto"},
      {"solutions.png", "AlessioCrypto"},
      {"garacky.png", "GARAKCY_eth"},
      {"kriollo.png", "CriolloInvestor"},
      {"pillsbury.png", "keithdpillsbury"},
      {"hanan.png", "xanan_the_Rad"},
      {"thing.png", "_i_thing"},
      {"mlbbetz.png", "MLBbetz"},
      {"logancatmug.png", "logancatmug"},
      {"badass.png", "batugan_kaw"},
      {"piwnik.png", "zapivcon"},
      {"khaalsu.png", "khaalsu"},
      {"muhibbsattar.png", "muhibbsattar"},
      {"megan.png", "MeganMar07"},
      {"theo.png", "sabercrunchers"},
      {"marty.png", "AndytownMarty"},
      {"mlbbetz.png", "mlbbetz"},
      {"corte.png", "Corte_Mortez"},
      {"stefan.png", "StefanDuee"},
      {"atasoy.png", "Hyppermedia"},
      {"reshma.png", "reshma2803"},
      {"crisision.png", "crisision_"},
      {"kdv.png", "KDVlieger"},
      {"kaitan.png", "kaitan67"},
      {"hashing.png", "KadenaHashing"},
      {"matta.png", "RyanMattaMedia"},
      {"radek.png", "RadekVrnak"},
      {"prince.png", "milady_prince28"},
      {"dov.png", "_dovgoruk"},
      {"stony.png", "Stoneym84"},
      {"tomnaka.png", "TomiNakamoto"}
    ]
  end
end
