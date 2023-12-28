defmodule KdabetFrontendWeb.Kings do
  use KdabetFrontendWeb, :surface_live_view

  alias KdabetFrontendWeb.Components.{King, KingModal}

  @impl true
  def mount(_params, _session, socket) do
    ## return the assigns
    kings = kingslist()
    lords = lordslist()

    {:ok,
     socket
     |> assign(id: socket.id)
     |> assign(kings: kings)
     |> assign(lords: lords)}
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
        <div class="glasscard glowtext font-exo-2 px-5 lg:px-10 mt-[10px] m-auto md:m-0 w-[400px] min-h-[250px] items-center lg:w-[400px] xl:w-[500px] align-center items-center">
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
        <div class="glowtext w-full flex flex-row justify-between">
          <h1 class="text-[1.75em] lg:text-[2.15em] xl:text-[2.7em] flex flex-row font-bold justify-start space-x-1 sm:space-x-2 lg:space-x-3">
            <span class="h-[40px] w-[40px] lg:h-[50px] lg:w-[50px] xl:h-[60px] xl:w-[60px]"><FontAwesome.LiveView.icon name="scroll" type="solid" class="crownicon" /></span>
            <span>Kings Collection</span>
          </h1>
          <p class="glowtext text-[1.75em] lg:text-[2.15em] xl:text-[2.7em]">{@kings |> length}/440</p>
        </div>

        <!-- Seperator -->
        <hr class="border-stone-700 my-4">

        <!-- Kings Collection List -->
        <div class="kingcontainer flex flex-wrap justify-center">
          <!-- Iterate through the kings -->
          <div class="w-full lg:mb-5 lg:w-[50%] my-2 max-w-2xl mx-auto" :for={{discord, name} <- @kings}>
            <King name={name} discord={discord} />
          </div>
        </div>

        <!-- Lords Section -->
        <div class="glowtext w-full flex flex-row justify-between">
          <h1 class="text-[1.75em] lg:text-[2.15em] xl:text-[2.7em] flex flex-row font-bold justify-start space-x-1 sm:space-x-2 lg:space-x-3">
            <span class="h-[40px] w-[40px] lg:h-[50px] lg:w-[50px] xl:h-[60px] xl:w-[60px]"><FontAwesome.LiveView.icon name="scroll" type="solid" class="crownicon" /></span>
            <span>Lords Row</span>
          </h1>
          <p class="glowtext text-[1.75em] lg:text-[2.15em] xl:text-[2.7em]">{@lords |> length}/57</p>
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

  defp kingslist() do
    [
      {"BaronRon021", "Baron Courtswayer"},
      {"JimmieDossHotep", "Captain Kincsem"},
      {"Amir", "DariusBytezar"},
      {"Halo77", "King Aryan"},
      {"ILikePow", "King Cat"},
      {"crob1985", "Peter K. Pact"},
      {"KDXLain", "Queen of Pixels"},
      {"teensfrommarz", "Mephisto"},
      {"RaiSM129", "Home Lezz"},
      {"Arunroohaayil", "King George"},
      {"Reese", "King RedBeard"},
      {"rafuael", "BuilderKing"},
      {"BoredInDaOffice", "Moking"},
      {"ezal_kda", "Marrok"},
      {"Teere35627623", "Unwise Hold Man"},
      {"Eddk147", "The Dawgfather King"},
      {"DanteSettles", "K:ween K:Lo"},
      {"Pow_Mooon1", "Slave Node King"},
      {"Pow_Mooon2", "Silicon King"},
      {"Pow_Mooon3", "King of Bags"},
      {"Paraci", "King Leonard II"},
      {"Hazen", "Lich King"},
      {"JamboyCrypto", "King T'challa"},
      {"CorteMortez", "King Jedidiah"},
      {"Sleachim", "Misch"},
      {"TheMarcus", "Surf King"},
      {"TheMarcus2", "Queen Of Slopes"},
      {"TheMarcus3", "King of the Book"},
      {"Mayoyo", "Lion King"},
      {"Markyboy", "Lupu Lupu"},
      {"Chantal", "Glass Queen"},
      {"Donald", "Koala Kat King"},
      {"kingofcigars", "King of Smoke"},
      {"No", "King No"},
      {"Forbes", "Hagar the Horrible"},
      {"Victoria_CG", "Queen Costa"},
      {"gaz.kda", "Radagast"},
      {"Olabero", "Sir 888"},
      {"Raoul85", "El Kapy"},
      {"KNico", "King Agility"},
      {"Linesman", "LeBron Chimpson III "},
      {"RamRaiderRico", "Golden Gambles"},
      {"Jack_Atta", "King of Pu$$y "},
      {"VimilionAryan", "BAT KING"},
      {"Snakecat", "King Snakecat"},
      {"Yusuf", "Jannissary king"},
      {"mom devi", "Kween Eagle"},
      {"Fabio", "HelioRegent"},
      {"Keyes", "King Leon"},
      {"Noah", "King Haber the Great"},
      {"KadenaUK", "UK King"},
      {"TheSportsbookBob", "Samoyed King"},
      {"Freeway", "Queen of the Road"},
      {"Lolaelsa", "Queen Popuri"},
      {"kMorgan", "King of Jazz"},
      {"Silkaitis", "Queen Alba"},
      {"dusma87", "WARDULENS"},
      {"LeGonze", "King of Ice Magic"},
      {"alex.kdasux", "Alise"},
      {"Archangel", "The Fallen One "},
      {"CasualMining", "King of Goats"},
      {"Johnolofs", "King of Odin's sun"},
      {"Emodius", "Magni"},
      {"Dodgerblu", "Laundering King"},
      {"Sournutt", "Sour One"},
      {"Markusro", "Lifting King"},
      {"Max", "Apex Signal"},
      {"realLouisM", "Duke Victor"},
      {"Arraweelo", "Arraweelo"},
      {"KristianCatering", "FRANZ BECKENBETTOR"},
      {"Slimtorian", "Lord Beener"},
      {"Kurator", "King K:urator"},
      {"Zotramid", "Void King"},
      {"Mikey", "King of K:ards"},
      {"EODvet98", "Bombsuit King"},
      {"StevieStar008", "Betting Starfish"},
      {"Marian", "King Dorian"},
      {"SansaL76", "Do Rag King"},
      {"Seankda", "King of Trek"},
      {"Debilisatore", "Satoshe"},
      {"Ron", "Ron - King of Wizards"},
      {"Kadena ireland", "King James"},
      {"CryptoSpyder", "King Spyder"},
      {"Temple", "King Amandla Kamari"},
      {"Janrya", "Poseidon\'s Queen"},
      {"KDAMiner", "King of the Game"},
      {"c4Crypto", "Hunting King"},
      {"JohnnyBeGood", "Osiris"},
      {"SuperSaucy", "King Antonio"},
      {"Azzacalabazza", "King Mamba"},
      {"Mavstar", "Heist King"},
      {"Kdadefi", "Queen Sorsha"},
      {"Pompey048", "Queen of Baskets"},
      {"42.kda", "King 42"},
      {"ThePromisedLand", "Manly King"},
      {"Shaboomi", "Iron King"},
      {"Spaceman", "Cricket Queen"},
      {"Rawnwolf", "Rawnwolf"},
      {"Pduivenb", "King McDuck"},
      {"Tomnakamoto", "King Tom"},
      {"Mikki", "KDA Queen Mikki"},
      {"DayaKrishin", "Croc King"},
      {"MrCheesington", "Xena Thornheart"},
      {"Needforspeed", "Calavera"},
      {"Kris_DV", "Fortuna"},
      {"Paulb", "Kalideoscope King"},
      {"Vixnu", "Vixnu"},
      {"ChurchKeeper", "Anastasia"},
      {"Haxtral", "Macao Queen"},
      {"Kaushal7", "King of Wizards"},
      {"Pbr713", "Paper Chaser"},
      {"ThicCkNRich", "King ThickNRich"},
      {"YahooooKDA", "King of Hits"},
      {"ShipPoster", "Loli Vampire Queen"},
      {"Fattzman", "King of Squats"},
      {"KdaWarrior", "Arkyn the great"},
      {"Tmg1", "Cactus King"},
      {"Tmg2", "Philly King"},
      {"Tmg3", "Kings of Crypto"},
      {"Frog", "King of Frogs"},
      {"Pineappleaura", "Lifting King"},
      {"Coop100", "Coop"},
      {"Aaron63", "King Teslatoshi"},
      {"Thizzle", "King of Dimensions"},
      {"BigThief", "King Floppa"},
      {"Ithing", "King of Pacts"},
      {"SadNorthwesternFan", "King NW WildKat"},
      {"Oneofadozen", "Kween Karma"},
      {"Ktitan", "Regulus Thunderclaw"},
      {"WhiteKid", "King James"},
      {"WhiteKid2", "King of Bitcoin"},
      {"Xor512", "Le Chuck"},
      {"Barry", "Technocore King"},
      {"MegMar07", "Kween MegMar"},
      {"Zeko", "King Zeko!"},
      {"DodgyMadGeezer", "Otter King"},
      {"IsThisArt", "King Shin Chan"},
      {"IMDC", "King King"},
      {"Poseidon", "King Poseiden"},
      {"RyanMatta", "King of Congress"},
      {"JustTony", "Kings Gambit KDA"},
      {"Shrump", "Chef Curry"},
      {"Waste", "King Smokey"},
      {"Modi", "PRATYUSH"},
      {"EvangalinePaul", "Queen Vi"},
      {"Oi", "Lucky Stephen"},
      {"KimTeach", "Queen of Teaching"},
      {"Esousa", "King K:osmos"},
      {"Fudo", "Fudo Myoo"},
      {"Vitja", "King of the Pirates"},
      {"Theezy", "Theezy"},
      {"Draofs", "Hywel Dda"},
      {"Ramaine", "King Chainz"},
      {"Joeleo13", "King Odinson"},
      {"Badass", "Queen Roigneach"},
      {"Headshot", "King Niall"},
      {"Mrs.C", "La Reine du Pari Sûr"},
      {"Ennead", "Dark King"},
      {"Leandrodkol", "Leandrodkl"},
      {"Kadtoshi", "The Goat"},
      {"Thenewtypetrader", "The Newtype King"},
      {"Iskander", "Panther King"},
      {"Cryptodzze", "Big Al"},
      {"Monique", "Queen Xotu"},
      {"NotAcee1x", "King DeadMau"},
      {"Miller77", "King Cadeyrn"},
      {"ӨNΣLΣGGΣDDAVΣ", "King Little Monster"},
      {"SlimCady", "Pacha Yachay"},
      {"XKDA", "King of the Rink"},
      {"Goldkross", "Mad King Popejoy"},
      {"Rymang", "King Maximus"},
      {"Shmocs", "King of Bets"},
      {"ElenaVik", "Yarn Queen"},
      {"Cawe4ka", "King Solomon"},
      {"Bells", "Francis of Assisi"},
      {"Zelos", "Queen Ella"},
      {"Xanan", "Kween Xana"},
      {"Paolla", "Paolla"},
      {"AlexBelieve", "King of 1984"},
      {"Mikeandwest", "King Kurgan"},
      {"MW", "King of Secrets"},
      {"ShadowMonarch", "Shadow Monarch"},
      {"Bettingcrypto", "Reptile King"},
      {"Hereby", "Ibn Fahdlan"},
      {"KadenaBC", "Robot King"},
      {"Revoo", "Beer King"},
      {"Lewis", "Boxing King"},
      {"Francisca_317", "Queen Francis"},
      {"Bren", "Moon Pup"},
      {"Hankdtank", "Ameriking"},
      {"BoneJeezy", "King Bone"},
      {"Mind2020", "Racer Queen"},
      {"DigitalApollyon", "Blue Wizard"},
      {"Zain", "Faceless King"},
      {"Fonk", "Zenobia"},
      {"StirlSilver", "King Stirling"},
      {"Jordanian", "King Jordainian"},
      {"Erre", "Forest Queen"},
      {"J7E-M", "King Fu*king Kong"},
      {"Giro", "King Leon the First"},
      {"SniperJ", "Sniper Queen"},
      {"Markmykda", "King of the Ring"},
      {"Kdpillsbury", "King of Blues"},
      {"FatCheetah", "King of Middle Earth"},
      {"Artic", "King of Ice"},
      {"Sophiascoins", "Queen of Colors"},
      {"Dabatola", "King Lazarus"},
      {"Surf777", "Turtle King"},
      {"DonutSmoker", "Beauregard"},
      {"Alberto", "King of The Seas"},
      {"Riley", "Otter King"},
      {"ElCid", "King El Cid"},
      {"MoleyBoy", "King of Moles"},
      {"Stone", "Orion"},
      {"Defiryansmith", "King of Guitar"},
      {"Fishman", "Lobster King"},
      {"Peter", "Giga-Dad"},
      {"ShaggyMatthew", "Shaggy"},
      {"LightBoltz", "Suit King"},
      {"Marvisofi", "Glorious Purpose"},
      {"KadenaCali", "Johnny Drama"},
      {"Mdot", "King of Chains"},
      {"Saschko", "King of the Hill"},
      {"Robin", "William Wallet"},
      {"NewKDA", "Moonwalker King"},
      {"MarginCalled", "Liquidation King"},
      {"DegAkal", "Voodoo King"},
      {"RonLaflamme", "Themis"},
      {"Udyahm", "Kdababa"},
      {"JkenLu", "King Pac"},
      {"Dankabull", "Nefrititi"},
      {"TipToe", "White Hat King"},
      {"Alecrypto", "Math King"},
      {"Elaiza", "Queen of the South"},
      {"Ele_1704", "Red Queen"},
      {"Buzz", "King of Hoops"},
      {"Bern1", "Queen of Auburn"},
      {"Mooni23", "Indian King"},
      {"OldCoder", "Old King"},
      {"Rihaan", "Flash King"},
      {"Sybil", "Archival Queen"},
      {"CaptainInsane", "The Dark Uncle"},
      {"Screens32", "Phoenix King"},
      {"RyanCronin", "Animation King"},
      {"Bushman", "King of Dice"}
    ]
  end

  defp lordslist() do
    []
  end

  @impl true
  def handle_event("show_modal", %{"uri" => uri, "name" => name}, socket) do
    KingModal.show("modal", uri, name)
    {:noreply, socket}
  end
end
