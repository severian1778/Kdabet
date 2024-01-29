import ConnectWithProvider from "./connect_with_provider"
import DisconnectProvider from "./disconnect_provider"
import FetchAccount from "./fetch_account"
import SignTransaction from "./sign_transaction"

//////////////////////////////////////////////////////
// Define an async function for connection with supported wallets
// ---------------------------------------------------
// The process of wallet connect is asynchronous! We 
// must away the reponse of the wallet before returning
// the state to the socket assigns.
//////////////////////////////////////////////////////
const connectWallet = async (scope, provider) => {
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

const signTransaction = async (scope, provider, unsigned_txn) => {
  // We then await the wallet connection promise
  promise = await SignTransaction(provider, unsigned_txn)
  // When the promise is returned we can return the hook 
  scope.pushEvent("return-signed", promise);
}

/* Exports listeners for various wallet functions */

WalletConnect = {
  mounted() {
    /* The listener awaits for a connect message*/
    window.addEventListener("phx:connect-wallet", (e) => {
      console.log(e)	
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

    /* The listener awaits for a signing message*/
    window.addEventListener("phx:sign-transaction", (e) => {
      signTransaction(this, e.detail.provider, e.detail.unsigned_txn)
    })

  }
}

export default WalletConnect;
