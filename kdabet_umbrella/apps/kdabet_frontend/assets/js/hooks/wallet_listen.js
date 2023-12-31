import ConnectWithProvider from "./connect_with_provider"
import DisconnectProvider from "./disconnect_provider"
import FetchAccount from "./fetch_account"
/* Import web3modal for wallet connect*/
import { createWeb3Modal, defaultWagmiConfig } from '@web3modal/wagmi'
//import { mainnet, kadena } from 'viem/chains'

//////////////////////////////////////////////////////
// Make a Request to wallet connect to acquire provider
// ---------------------------------------------------
// This is the standard v3 method to connect to a wallet
//////////////////////////////////////////////////////

/*
const projectId = '1d0464cb744fc1c491260051af7618f0'

const metadata = {
  name: 'Web3Modal',
  description: 'Web3Modal Example',
  url: 'https://web3modal.com',
  icons: ['https://avatars.githubusercontent.com/u/37784886']
}

const chains = ["kadena:mainnet01"] //[mainnet, kadena]
const wagmiConfig = defaultWagmiConfig({ chains, projectId, metadata })

// 3. Create modal
const modal = createWeb3Modal({ wagmiConfig, projectId, chains })
*/

//////////////////////////////////////////////////////
// Define an async function for connection with supported wallets
// ---------------------------------------------------
// The process of wallet connect is asynchronous! We 
// must away the reponse of the wallet before returning
// the state to the socket assigns.
//////////////////////////////////////////////////////
const connectWallet = async (scope, provider) => {
  console.log(scope, provider)
  // We then await the wallet connection promise
  promise = await ConnectWithProvider(provider)
  // When the promise is returned we can return the hook 
  scope.pushEvent("connect-response", promise);  
}

const disconnectWallet = async (scope, details) => {
  // We then await the wallet connection promise
  promise = await DisconnectProvider(details.session, details.provider, details.networkId)
  // When the promise is returned we can return the hook 
  scope.pushEvent("disconnect-response", promise);
}

const fetchAccount = async (scope, provider) => {
  // We then await the wallet connection promise
  promise = await FetchAccount(provider)
  // When the promise is returned we can return the hook 
  scope.pushEvent("fetch-account-response", promise);
}


/* Exports listeners for various wallet functions */

WalletConnect = {
  mounted() {
    /* The listener awaits for a connect message*/
    window.addEventListener("phx:connect-wallet", (e) => {
      connectWallet(this, e.detail.provider)
    })

    /* The listener awaits for a wallet balance */
    window.addEventListener("phx:fetch-account", (e) => {
      fetchAccount(this, e.detail.provider)
    })

    /* The listener awaits for a disconnect message*/
    window.addEventListener("phx:disconnect-wallet", (e) => {
      disconnectWallet(this, e.detail)
    })
  }
}

export default WalletConnect;
