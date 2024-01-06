defmodule KdabetFrontendWeb.Mint do
  use KdabetFrontendWeb, :surface_live_view
  alias KdabetFrontendWeb.Components.{MintModal}

  @impl true
  def mount(_params, _session, socket) do
    #################################################
    ## The Various States of Wallet Management
    ## -----------------------------------------------
    ## Wallet State => Manages the response from the provider
    ## Kadena State => Manages Kadena transactions
    ## WC State => Wallet Connect Protocol Modal
    #################################################

    ## The account state
    walletState = %{
      account: "",
      session: nil,
      guard: [],
      pubkey: "",
      provider: "",
      balance: ""
    }

    ## Wallet Connect is a 3rd party app with its own state
    walletConnect = %{
      useWalletConnectStore: %{
        selectedAccount: nil,
        signingType: "sign"
      }
    }

    ## The Kadena State
    kadenaState = %{
      messages: [],
      newMessage: %{},
      requestKeys: [],
      transactions: [],
      newTransaction: %{},
      contractAccount: ~c"",
      netInfo: %{
        # import.meta.env.VITE_MARMALADE_V2,
        contract: "free.kdabet",
        # Number(import.meta.env.VITE_CHAIN_ID),
        chainId: 8,
        ## Number(import.meta.env.VITE_GAS_PRICE),
        gasPrice: 0.00001,
        ## Number(import.meta.env.VITE_GAS_LIMIT),
        gasLimit: 5000,
        # import.meta.env. VITE_KDA_NETWORK,
        network: "https://api.chainweb.com/",
        # import.meta.env.VITE_NETWORK_ID,
        networkId: "mainnet01",
        ttl: 600
      }
    }

    ## The WC state
    wcState = %{showModal: false}

    #################################################
    ## Connect Button Management
    #################################################
    connectButton = %{
      func: "",
      hook: "WalletConnect",
      innertext: "WalletConnect",
      working: false,
      provider: "",
      event: "open = true"
    }

    #################################################
    ## User Data
    #################################################
    userData = %{
      imagename: "UnderConstruction",
      ipfs: "",
      kingname: "My King",
      is_minted: false
    }

    {:ok,
     assign(socket,
       walletState: walletState,
       kadenaState: kadenaState,
       wcState: wcState,
       connectButton: connectButton,
       userData: userData
     )}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="flex flex-col max-w-6xl mx-auto space-y-10">
      <div class="w-full flex flex-row justify-center mt-[30px] lg:my-[30px] w-full">
        <!-- Dashboard -->
        <section class="w-full">
          <div class="w-full font-exo2 text-stone-200 font-bold space-y-2">
            <h1 class="w-full text-center text-5xl">Mint a KDA king</h1>
            <h2 class="w-full text-center text-4xl">Rule the Betting Kingdom.</h2>
          </div>
        </section>
      </div>
      <!-- Pre-Amble -->
      <div class="font-exo2 text-2xl text-stone-200 flex flex-col lg:flex-row">
        <img
          class="rounded-md border-2 border-stone-200 hidden lg:block w-[300px] h-[300px] mx-auto lg:m-0"
          src="/images/mintking.png"
        />
        <p class="flex-1 px-5 lg:pl-10">Thank you for purchasing a Kadena King NFT.   The Kadena King is a special utility NFT that offers a 0.2% equal share of the work product with respect to the KDAbet sports betting and casino operator.  The Kadena king NFT offers the holder the ability to govern the future of the protocol, make a steady passive income and take part in the growth mechanic of the operator.<br><br>Please follow the directions and let your reign begin!</p>
      </div>
      <!-- Paragraph seperator -->
      <img class="mx-auto" src="/images/crownseperator.png">
      <!-- Step 1 -->
      <div class="flex flex-col lg:flex-row">
        <div class="w-100 max-w-xl mx-auto lg:mx-0 lg:w-1/2 lg:max-w-1/2 font-exo2 text-stone-200">
          <div class="space-y-5">
            <h2 class="font-bold text-4xl text-center">Connect Your Wallet:</h2>
            <h3 class="text-2xl px-5 lg:px-0">Choose a supported Maramlade NG provider.  Your wallet details will show up in the dashboard</h3>
          </div>
          <!-- Wallet Details -->
          <section class="glasscard w-full px-6 py-5 mt-10 mb-[30px]">
            <ul class="list-none font-exo2 text-stone-200 text-xl w-full space-y-1">
              <li class="flex flex-row justify-start">
                <span class="w-24 font-bold">Wallet:</span>
                <span>
                  {#if assigns.walletState.account != ""}
                    {Enum.join([
                      assigns.walletState.account |> String.slice(0, 10),
                      "...",
                      assigns.walletState.account |> String.reverse() |> String.slice(0, 10) |> String.reverse()
                    ])}
                  {/if}
                </span>
              </li>
              <li class="flex flex-row justify-start">
                <span class="w-24 font-bold">Provider:</span>
                <span>{assigns.walletState.provider}</span>
              </li>
              <li class="flex flex-row justify-start">
                <span class="w-24 font-bold">Balance:</span>
                <span>{assigns.walletState.balance}</span>
              </li>
              <!-- <li class="flex flex-row justify-between"><span>messages: {assigns.kadenaState.messages|>elem(0)}</span></li> -->
            </ul>
          </section>
        </div>
        <div class="mx-auto lg:mx-0 w-1/2 max-width-1/2">
          <!-- Wallet Connect Dropdown -->
          <section class="w-full" x-data="{ open: false }">
            <!-- Connect Button -->
            <button
              class="connectButton"
              x-on:click={assigns.connectButton.event}
              id="connectButton"
              :on-click={assigns.connectButton.func}
              phx-value-wallet={assigns.connectButton.provider}
              phx-hook={assigns.connectButton.hook}
            >
              <img class="w-[30px] h-[30px]" :if={@connectButton.working} src="/images/pulse.gif">
              <span>{assigns.connectButton.innertext}</span>
            </button>

            <!-- Disc -->
            <div
              class="w-60 rounded-md bg-sky-700 overflow-hidden mx-auto"
              x-show="open"
              @click="open=false"
              @click.away="open = false"
            >
              <ul class="wallet-select-list">
                <li id="koala_connect" :on-click="connectWithProvider" phx-value-wallet="koala">
                  <img src="/images/koala.png">
                  <span>Koala Wallet</span>
                </li>
                <li id="ecko_connect" :on-click="connectWithProvider" phx-value-wallet="ecko">
                  <img src="/images/ecko.png">
                  <span>Ecko Wallet</span>
                </li>
                <li id="zelcore_connect" :on-click="connectWithProvider" phx-value-wallet="zelcore">
                  <img src="/images/zelcore.png">
                  <span>Zelcore Wallet</span>
                </li>
                <!-- <li id="wallet_connect" :on-click="connectWithProvider" phx-value-wallet="wc">
                  <img src="/images/walletconnect.png">
                    <span>Wallet Connect</span>
                    <w3m-button />
                  </li>-->
              </ul>
            </div>
          </section>
        </div>
      </div>
      <!-- Paragraph seperator -->
      <img class="mx-auto mt-[30px]" src="/images/crownseperator.png">
      <!-- Step 2 -->
      <div class="flex flex-col lg:flex-row">
        <div class="w-100 max-w-4xl mx-auto lg:mx-0 lg:w-1/2 lg:max-w-1/2 font-exo2 text-stone-200">
          <div class="space-y-5">
            <h2 class="font-bold text-4xl text-center">Confirm Your King/Kween</h2>
            <h3 class="hidden md:block px-5 text-2xl">A king can only be minted if your wallet is recorded as immutable data in the Kadena Kings NG mint smart contract.  If you are not on the whitelist, you cannot mint.<br class="hidden lg:block"><br class="hidden lg:block">If a king has appeared in the prompt on the right hand side, this means you can mint a king.  Please confirm this is your Kadena king.</h3>
            <!-- Mint Button -->
            <div class="hidden lg:block lg:w-1/2 !mt-10 mx-auto">
              <button class="connectButton">This is my King</button>
            </div>
          </div>
        </div>
        <!-- King Data -->
        <div class="w-100 max-w-xl mx-auto mt-10 lg:mt-0 lg:mx-0 lg:w-1/2 lg:max-w-1/2 font-exo2 text-stone-200 flex flex-col text-2xl font-bold space-y-2">
          <img
            class="rounded-md border-2 border-stone-300 w-[400px] h-[400px] mx-auto"
            src={"/images/kings/" <> assigns.userData.imagename <> ".png"}
          />
          <h2 class="flex flex-row justify-between w-[400px] mx-auto">
            <span>Name:</span>
            <span>{assigns.userData.kingname}</span>
          </h2>
          <h2 class="flex flex-row justify-between w-[400px] mx-auto">
            <span>IPFS</span>
            <a
              class="text-sky-400 hover:text-pink-300"
              href={"https://maroon-obedient-hawk-618.mypinata.cloud/ipfs/" <> assigns.userData.ipfs}
            >
              {#if assigns.userData.ipfs != ""}
                {Enum.join([
                  assigns.userData.ipfs |> String.slice(0, 5),
                  "...",
                  assigns.userData.ipfs |> String.reverse() |> String.slice(0, 5) |> String.reverse()
                ])}
              {/if}
            </a>
          </h2>
          <!-- Mint Button -->
          <div class="block lg:hidden lg:w-1/2 !mt-10 mx-auto lg:mx-0">
            <button class="connectButton">This is my King</button>
          </div>
        </div>
      </div>
      <!-- Paragraph seperator -->
      <img class="mx-auto mt-[30px]" src="/images/crownseperator.png">
      <!-- Step 3 -->
      <div class="flex flex-col lg:flex-row">
        <div class="w-100 max-w-2xl lg:w-1/2 lg:max-w-1/2 font-exo2 text-stone-200">
          <div class="space-y-5">
            <h2 class="font-bold text-4xl text-center">Mint Your King:</h2>
            <h3 class="text-2xl px-5 lg:px-0">Take your rightful throne and mint the king.
            </h3>
          </div>
          <!-- Wallet Details -->
          <section class="glasscard w-full px-6 py-5 mt-10 mb-[30px]">
            <ul class="list-none font-exo2 text-stone-200 text-xl w-full space-y-1">
              <li class="flex flex-row justify-start">
                <span class="w-36 font-bold">Txn Sent:</span>
                <span />
              </li>
              <li class="flex flex-row justify-start">
                <span class="w-36 font-bold">Txn Confirmed:</span>
                <span />
              </li>
              <li class="flex flex-row justify-start">
                <span class="w-36 font-bold">Explorer:</span>
                <span />
              </li>
            </ul>
          </section>
        </div>
        <!-- Mint Button -->
        <div class="w-1/2 mt-5 mx-auto">
          <button class="connectButton">Mint the King</button>
        </div>
      </div>
      <!-- Paragraph seperator -->
      <img class="mx-auto mt-[30px]" src="/images/crownseperator.png">
      <!-- Step 4 -->
      <div class="flex flex-col lg:flex-row">
        <div class="w-100 max-w-2xl lg:w-1/2 lg:max-w-1/2 font-exo2 text-stone-200">
          <div class="space-y-5">
            <h2 class="font-bold text-4xl text-center">Join the DAO:</h2>
            <h3 class="text-2xl px-5 lg:px-0">As the Ruler of KDAbet you must join the council of Kings.  Please register your wallet on the Swarms DAO software <a
                class="hover:text-pink-300 text-sky-300"
                href="https://dao.swarms.finance/dao/ZCo5s3nlXkBbXmjduTDPTS_a1nlbVWKyGoV0uWLDU5E"
              >here.</a>
            </h3>
          </div>
        </div>
        <!-- Swarms Data -->
        <div class="w-100 lg:w-1/2 lg:max-w-1/2 font-exo2 text-stone-200 flex flex-col text-2xl font-bold space-y-2">
          <img
            class="rounded-md border-2 mt-10 lg:mt-0 border-stone-300 w-[400px] h-[400px] mx-auto"
            src="/images/swarms.png"
          />
        </div>
      </div>
      <!-- Paragraph seperator -->
      <img class="mx-auto mt-[30px]" src="/images/crownseperator.png">
      <!-- Thank You -->
      <div class="flex flex-col text-stone-200 font-exo2 text-center space-y-10">
        <h2 class="text-4xl">Thank you for becoming a fellow in the only decentralized ownership casino/sportsbook in the world.</h2>
        <h1 class="text-2xl">Together we strive to make Kadena the destination for bettors who want complete freedom to enjoy their hobby, free from profiteering.</h1>
        <img class="mx-auto w-[100px] h-[100px]" src="/images/thronelogo.png">
      </div>

      <!-- Modal Popup -->
      <MintModal id="modal" />
    </div>
    """
  end

  ###########################################
  ## Event Handlers for connect button events
  ## pushes events to wallet_listen.js
  ###########################################
  @impl true
  def handle_event("connectWithProvider", %{"wallet" => provider}, socket) do
    newConnectButton =
      %{
        socket.assigns.connectButton
        | func: "",
          innertext: "Connecting...",
          working: true,
          event: ""
      }

    {:noreply,
     socket
     |> assign(connectButton: newConnectButton)
     |> push_event("connect-wallet", %{provider: provider})}
  end

  @impl true
  def handle_event("disconnectProvider", _providerID, socket) do
    provider = socket.assigns.walletState.provider
    session = socket.assigns.walletState.session
    networkId = socket.assigns.kadenaState.netInfo.networkId

    ######################################
    ## Update the Connect Button
    ######################################
    newConnectButton =
      %{
        socket.assigns.connectButton
        | func: "",
          innertext: "Wallet Connect",
          working: false,
          provider: "",
          event: "open = true"
      }

    {:noreply,
     socket
     |> assign(connectButton: newConnectButton)
     |> push_event("disconnect-wallet", %{
       provider: provider,
       session: session,
       networkId: networkId
     })}
  end

  @impl true
  def handle_event("connect-response", response_from_client, socket) do
    # TODO: make sure to update the wc state

    ###########################################
    ## Update the socket states with the response
    ## from the wallet (javascript)
    ###########################################
    newWalletState =
      socket.assigns.walletState
      |> Map.update!(:account, fn _oldaccount -> response_from_client["account"] end)
      |> Map.update!(:pubkey, fn _oldaccount -> response_from_client["pubKey"] end)
      |> Map.update!(:provider, fn _oldaccount -> response_from_client["provider"] end)

    newKadenaState =
      socket.assigns.kadenaState
      |> Map.update!(:messages, fn _oldaccount ->
        socket.assigns.kadenaState.messages ++
          [{response_from_client["messages"], DateTime.utc_now()}]
      end)

    ###########################################
    ## Update the connect button
    ###########################################
    newConnectButton =
      %{
        socket.assigns.connectButton
        | func: "disconnectProvider",
          innertext: "Disconnect",
          working: false
      }

    ###########################################
    ## Handle valid/invalid wallets
    ###########################################
    KdabetFrontend.Kings.get_king(response_from_client["account"])
    |> case do
      nil ->
        newConnectButton =
          %{
            socket.assigns.connectButton
            | func: "WalletConnect",
              innertext: "WalletConnect",
              working: false,
              event: "open=true"
          }

        ## Fire the Show Modal Event For Wallet not Whitelisted.
        MintModal.show("modal", response_from_client["account"], response_from_client["provider"])

        {:noreply,
         socket
         |> assign(connectButton: newConnectButton)
         |> push_event("disconnect-wallet", %{provider: response_from_client["provider"]})}

      {_address, imgname, kingname, im, ipfs} ->
        ## populate the user data from the kings GenServer
        newUserData =
          %{
            socket.assigns.userData
            | imagename: imgname,
              kingname: kingname,
              is_minted: im,
              ipfs: ipfs
          }

        ## Note: We push the wallet fetch balance event after connection is secure.
        {:noreply,
         socket
         |> assign(
           walletState: newWalletState,
           kadenaState: newKadenaState,
           connectButton: newConnectButton,
           userData: newUserData
         )
         |> push_event("fetch-account", %{provider: response_from_client["provider"]})}
    end
  end

  @impl true
  def handle_event("fetch-account-response", response_from_client, socket) do
    newWalletState =
      %{
        socket.assigns.walletState
        | balance:
            (response_from_client["balance"] |> Decimal.round(2) |> to_string()) <>
              " KDA / $0.00 USD"
      }

    {:noreply, assign(socket, walletState: newWalletState)}
  end

  @impl true
  def handle_event("disconnect-response", response_from_client, socket) do
    # TODO: make sure to update the wc state

    ###########################################
    ## Update the socket states with the response
    ## from the wallet (javascript)
    ###########################################
    newWalletState =
      socket.assigns.walletState
      |> Map.update!(:account, fn _oldaccount -> "" end)
      |> Map.update!(:pubkey, fn _oldaccount -> "" end)
      |> Map.update!(:provider, fn _oldaccount -> "" end)
      |> Map.update!(:balance, fn _oldaccount -> "" end)

    newKadenaState =
      socket.assigns.kadenaState
      |> Map.update!(:messages, fn _oldaccount ->
        socket.assigns.kadenaState.messages ++
          [{response_from_client["messages"], DateTime.utc_now()}]
      end)

    ###########################################
    ## Update the connect button
    ###########################################
    newConnectButton =
      %{
        socket.assigns.connectButton
        | func: "",
          innertext: "Connect Wallet",
          provider: ""
      }

    ###########################################
    ## Update the king data
    ###########################################
    newUserData =
      %{
        socket.assigns.userData
        | imagename: "UnderConstruction",
          kingname: "My King",
          ipfs: ""
      }

    {:noreply,
     assign(socket,
       walletState: newWalletState,
       kadenaState: newKadenaState,
       connectButton: newConnectButton,
       userData: newUserData
     )}
  end
end
