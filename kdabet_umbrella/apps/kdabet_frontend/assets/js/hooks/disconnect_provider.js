import {EVENT_WALLET_DISCONNECT} from "./constants"
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
const DisconnectProvider = async (session, providerId, networkId) => {
  let provider = fetch_provider(providerId);
  let disconnectResult

  try {
    disconnectResult = await provider.disconnect();

    if (disconnectResult.result.status === 'success') {
      /* extracting state variables from Koala Response*/
      const state = {
        account: "",
        provider: null,
        session: null,
        showModal: false,
        pubKey: "",
        messages: `Successfully Disconnected from ${provider.name}`
      }

      /* Create a custom event that broadcasts a provider key value pair to any listeners*/
      const event = new CustomEvent(EVENT_WALLET_DISCONNECT, { detail: providerId });
      document.dispatchEvent(event);
     
      console.log(state)
      return state
    } else {
      const state = {
        messages: `Error: ${disconnectResult.message}. Make sure you are on ${networkId}`
      }

      return state
    }
  }catch(e){
    console.log("Error during disconnection:", e);
  }
}

export default DisconnectProvider;
