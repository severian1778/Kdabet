import {EVENT_FETCH_ACCOUNT} from "./constants"
import KoalaWallet from "./wallet-connect/providers/koala"
import EckoWallet from "./wallet-connect/providers/ecko"
import ZelcoreWallet from "./wallet-connect/providers/zelcore"
import WalletConnect from "./wallet-connect/providers/wc"

/* Fetches the provider object from a string */
const fetch_provider = (pid) => {
  switch (pid) {
    case "koala":
      return KoalaWallet
    case "ecko":
      return EckoWallet
    case "zelcore":
      return ZelcoreWallet
    case "wc":
      return WalletConnect
    default:
      console.log("There is no provider object for "+pid)
  }
}

/* A simple export for a hello world connectivity check */
const FetchAccount = async (providerId) => {
  let provider = fetch_provider(providerId);
  let accountFetchResult

  try {
    console.log(provider)
    accountFetchResult = await provider.fetch_account();

    if (accountFetchResult.status === 'success') {
      console.log(accountFetchResult) 
      /* extracting state variables fromwallet response*/
      let balance = typeof accountFetchResult.balance === "undefined" || !accountFetchResult.balance ? 0.0 : accountFetchResult.balance;

      const state = {
        balance: balance,
        messages: `Successfully fetched balance of ${balance} from ${accountFetchResult.wallet.account}`
      }
 
      /* Create a custom event that broadcasts a provider key value pair to any listeners*/
      const event = new CustomEvent(EVENT_FETCH_ACCOUNT, { detail: providerId});
      document.dispatchEvent(event);
     
      return state
    } else {
      const state = {
        messages: `Error: ${accountFetchResult.message}. The account could not be pinged`
      }

      return state
    }
  }catch(e){
    console.log("Error during disconnection:", e);
  }
}

export default FetchAccount;
