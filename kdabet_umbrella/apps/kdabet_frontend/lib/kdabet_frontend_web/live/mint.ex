defmodule KdabetFrontendWeb.Mint do
  use KdabetFrontendWeb, :surface_live_view
  alias KdabetFrontendWeb.Components.{MintModal}
  alias KdabetFrontend.Kings.{Transactions, Cache}

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
      balance_kda: 0,
      balance_usd: 0,
      balance_string: ""
    }

    ## Wallet Connect is a 3rd party app with its own state
    _walletConnect = %{
      useWalletConnectStore: %{
        selectedAccount: nil,
        signingType: "sign"
      }
    }

    ## Wallet Connect is a 3rd party app with its own state
    txnState = %{
      req_key: "",
      poll: "",
      is_confirmed: false,
      blocktime: "",
      response: ""
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
      innertext: "Connect Wallet",
      working: false,
      provider: "",
      event: "open = true"
    }

    #################################################
    ## Connect Button Management
    #################################################
    mintButton = %{
      has_loaded_nft: false,
      has_confirmed_nft: false,
      hook: "SignTransaction",
      provider: ""
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
       txnState: txnState,
       connectButton: connectButton,
       mintButton: mintButton,
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
                <span>{assigns.walletState.balance_string}</span>
              </li>
              <!-- <li class="flex flex-row justify-between"><span>messages: {assigns.kadenaState.messages|>elem(0)}</span></li> -->
            </ul>
          </section>
        </div>
        <div class="mx-auto lg:mx-0 w-1/2 max-width-1/2">
          <!-- Wallet Connect Dropdown -->
          <section class="w-full space-y-10" x-data="{ open: false }">
            <h2 class="font-exo2 text-stone-200 text-center w-full text-3xl">Supported Wallets</h2>
            <div class="mx-auto max-w-[320px] flex flex-row justify-between space-x-3">
              <!-- <img class="w-[60px] h-[60px]" src="images/linx.png"> -->
              <img class="w-[60px] h-[60px]" src="images/koala.png">
              <img class="w-[60px] h-[60px]" src="images/ecko.png">
              <img class="w-[60px] h-[60px]" src="images/zelcore.png">
            </div>
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
            {#if assigns.mintButton.has_loaded_nft}
              <div class="hidden lg:block lg:w-1/2 !mt-16 mx-auto">
                <button :on-click="confirm_nft" class="connectButton">This is my King</button>
              </div>
            {#else}
              <div class="hidden lg:block lg:w-1/2 !mt-16 mx-auto">
                <button class="disabledButton">This is my King</button>
              </div>
            {/if}
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
          {#if assigns.mintButton.has_loaded_nft}
            <div class="block lg:hidden lg:w-1/2 !mt-10 mx-auto">
              <button :on-click="confirm_nft" class="connectButton">This is my King</button>
            </div>
          {#else}
            <div class="block lg:hidden lg:w-1/2 !mt-10 mx-auto">
              <button class="disabledButton">This is my King</button>
            </div>
          {/if}
        </div>
      </div>
      <!-- Paragraph seperator -->
      <img class="mx-auto mt-[30px]" src="/images/crownseperator.png">
      <!-- Step 3 -->
      <div class={"flex flex-col lg:flex-row " <>
        (((assigns.mintButton.has_confirmed_nft or assigns.txnState.is_confirmed) && "opacity-100") ||
           "opacity-50")}>
        <div class="w-full max-w-2xl lg:w-1/2 lg:max-w-1/2 font-exo2 text-stone-200">
          <div class="space-y-5">
            <h2 class="font-bold text-4xl text-center">Mint Your King:</h2>
            <h3 class="text-2xl px-5 lg:px-0">Take your rightful throne and mint the king.
            </h3>
          </div>
          <!-- Wallet Details -->
          <section class="glasscard w-full px-6 py-5 mt-10 mb-[30px]">
            <ul class="list-none font-exo2 text-stone-200 text-xl w-full space-y-1">
              <li class="flex flex-row justify-between">
                <span class="w-36 font-bold">Txn Sent:</span>
                <span>
                  {#if assigns.userData.ipfs != ""}
                    {Enum.join([
                      assigns.txnState.req_key |> String.slice(0, 5),
                      "...",
                      assigns.txnState.req_key |> String.reverse() |> String.slice(0, 5) |> String.reverse()
                    ])}
                  {/if}
                </span>
              </li>
              <li class="flex flex-row justify-between">
                <span class="w-36 font-bold">Txn Confirmed:</span>
                <span>{assigns.txnState.is_confirmed}</span>
              </li>
              <li class="flex flex-row justify-between">
                <span class="w-36 font-bold">Explorer:</span>
                <span>
                  <a
                    class="text-sky-400 hover:text-pink-300"
                    href={"https://explorer.chainweb.com/testnet/tx/" <> assigns.txnState.req_key}
                  >
                    {Enum.join([
                      ("https://explorer.chainweb.com/testnet/tx/" <> assigns.txnState.req_key)
                      |> String.slice(0, 10),
                      "...",
                      ("https://explorer.chainweb.com/testnet/tx/" <> assigns.txnState.req_key)
                      |> String.reverse()
                      |> String.slice(0, 5)
                      |> String.reverse()
                    ])}
                  </a>
                </span>
              </li>
            </ul>
          </section>
        </div>
        <!-- Mint Button -->
        {#if assigns.mintButton.has_confirmed_nft}
          {#if assigns.txnState.is_confirmed}
            <div class="glasscard mx-auto">
              <img class="" src="images/ThankYouForMinting.png">
            </div>
          {#else}
            <div class="lg:w-1/2 mt-5 mx-auto">
              <div class="flex flex-col w-full text-center text-stone-200 font-bold font-exo2 mb-10 space-y-1">
                <span class="text-4xl mb-2">Cost: $300 USD</span>
                <span class="text-2xl">Wallet: {assigns.walletState.balance_string |> String.split("/") |> Enum.at(0)}</span>
                <span class="text-2xl">Wallet: {assigns.walletState.balance_string |> String.split("/") |> Enum.at(1)}</span>
              </div>
              {#if assigns.walletState.balance_usd < 300.00}
                <div class="text-red-300 text-center text-red-300 font-bold font-exo-2 my-10">Insufficient Funds</div>
                <div class="lg:w-1/2 mt-5 mx-auto">
                  <!-- The Grayed out Button -->
                  <button class="disabledButton">Mint the King</button>
                </div>
              {#else}
                <button
                  :on-click="mintToken"
                  class="connectButton"
                  phx-value-wallet={assigns.mintButton.provider}
                  phx-hook={assigns.mintButton.hook}
                >Mint the King</button>
              {/if}
            </div>
          {/if}
        {#else}
          {#if assigns.txnState.is_confirmed}
            <div class="glasscard mx-auto">
              <img class="" src="images/ThankYouForMinting.png">
            </div>
          {#else}
            <div class="w-1/2 mt-5 mx-auto">
              <!-- The Grayed out Button -->
              <button class="disabledButton">Mint the King</button>
            </div>
          {/if}
        {/if}
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
    {:ok, raw_balance} = Transactions.get_balance(response_from_client["account"])
    {:ok, raw_price} = Transactions.get_kda_price()
    balance = raw_balance.result.data.balance
    price = raw_price.result.data |> Map.get(:"kda-usd-price")
    ###########################################
    ## Update the socket states with the response
    ## from the wallet (javascript)
    ###########################################
    newWalletState =
      socket.assigns.walletState
      |> Map.update!(:account, fn _oldaccount -> response_from_client["account"] end)
      |> Map.update!(:pubkey, fn _oldaccount -> response_from_client["pubKey"] end)
      |> Map.update!(:provider, fn _oldaccount -> response_from_client["provider"] end)
      |> Map.update!(:balance_kda, fn _oldaccount -> balance end)
      |> Map.update!(:balance_usd, fn _oldaccount -> balance * price end)
      |> Map.update!(:balance_string, fn _oldaccount ->
        Enum.join([
          balance
          |> to_string
          |> Float.parse()
          |> elem(0)
          |> Decimal.from_float()
          |> Decimal.round(2)
          |> to_string(),
          " KDA / $",
          (price * balance)
          |> Decimal.from_float()
          |> Decimal.round(2)
          |> to_string(),
          " USD"
        ])
      end)

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
    ## Set the transaction state
    ###########################################
    txnState =
      Cache.get(:kings, response_from_client["account"])
      |> case do
        ## If no transaction recorded,  register it for the first time
        {:ok, nil} ->
          Cache.put(:kings, response_from_client["account"], socket.assigns.txnState)
          socket.assigns.txnState

        ## if transaction is recorded and poll is not populated,  poll
        {:ok, response} ->
          cond do
            response.req_key == "" ->
              socket.assigns.txnState

            true ->
              {:ok, poll} = Transactions.poll_transaction(response.req_key)

              is_success =
                case poll.results do
                  [] -> "pending"
                  a -> a |> Enum.at(0) |> Map.get(:result) |> Map.get(:status)
                end

              case is_success do
                "failure" ->
                  %{response | poll: poll, is_confirmed: false}

                "success" ->
                  %{response | poll: poll, is_confirmed: true}

                _ ->
                  response
              end
          end
      end

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

        ## Flip Confirm Mint Button to on status
        newMintButton = %{
          socket.assigns.mintButton
          | has_loaded_nft: true,
            provider: response_from_client["provider"]
        }

        ## Note: We push the wallet fetch balance event after connection is secure.
        {:noreply,
         socket
         |> assign(
           walletState: newWalletState,
           kadenaState: newKadenaState,
           connectButton: newConnectButton,
           mintButton: newMintButton,
           userData: newUserData,
           txnState: txnState
         )}
    end
  end

  @impl true
  def handle_event("return-signed", response_from_client, socket) do
    ## Forms an unsigned transactions
    {:ok, response} =
      Transactions.sign_and_send(response_from_client, :send)

    ## Fetch request keys
    req_key =
      cond do
        is_map_key(response, :request_keys) -> response.request_keys |> Enum.at(0)
        true -> response.req_key
      end

    Cache.put(:kings, socket.assigns.walletState.account, %{
      socket.assigns.txnState
      | req_key: req_key
    })

    {:noreply,
     socket
     |> assign(txnState: %{socket.assigns.txnState | req_key: req_key})}
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
      |> Map.update!(:balance_string, fn _oldaccount -> "" end)
      |> Map.update!(:balance_kda, fn _oldaccount -> 0.0 end)
      |> Map.update!(:balance_usd, fn _oldaccount -> 0.0 end)

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

  @impl true
  def handle_event("confirm_nft", _response, socket) do
    newMintButton = %{socket.assigns.mintButton | has_confirmed_nft: true}
    {:noreply, assign(socket, mintButton: newMintButton)}
  end

  @impl true
  def handle_event("mintToken", %{"wallet" => provider}, socket) do
    ## Forms an unsigned transactions
    unsigned_txn = Transactions.prep_unsigned_txn(socket.assigns.walletState.pubkey)

    safe_unsigned_txn =
      unsigned_txn
      |> Jason.encode!()

    ## Send transaction to provider for signature
    {:noreply,
     socket
     |> push_event("sign-transaction", %{
       provider: provider,
       unsigned_txn: safe_unsigned_txn
     })}
  end
end
