import {EVENT_WALLET_CONNECT} from "./constants"
import KoalaWallet from "./wallet-connect/providers/koala"
import EckoWallet from "./wallet-connect/providers/ecko"
import ZelcoreWallet from "./wallet-connect/providers/zelcore"
import WalletConnect from "./wallet-connect/providers/wc"

/* Wallet Connection */
/*const network_id = "testnet04"*/
const network_id = "mainnet01"


/* Fetches the provider object from a string */
const fetch_provider = (pid) => {
  console.log(pid)
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

/* A simple export for a wallet connectivity */
const ConnectWithProvider = async (providerID) => {
  /* TODO dynamically detect the network ID */
  let networkID = network_id;
  let provider = fetch_provider(providerID);
  let connectResult;
    
  try{
    connectResult = await provider.connect();
    console.log(connectResult)
    /* store Koala response in the state manager */
    if (connectResult.status === 'success') {

      /* extracting state variables from Koala Response*/
      const state = {
        account: connectResult.account.account,
        provider: providerID,
        session: connectResult.session,
        showModal: false,
        pubKey: connectResult.account.publicKey,
        messages: `connected to ${providerID}`
      }

      /* Create a custom event that broadcasts a provider key value pair to any listeners*/
      const event = new CustomEvent(EVENT_WALLET_CONNECT, { detail: providerID });
      document.dispatchEvent(event);

      return state
    }else {
      const state = {
        messages: `Error: ${connectResult.message}. Make sure you are on ` 
      }

      return state
    }
  } catch(e) {
    console.log("Error during connection:", e);
  }
}

//Returns an object of objects representing the wallet connect state
export const useWalletConnect = () => {
  const {
    selectedAccount,
    signingType,
    setSelectedAccount,
    setSigningType
  } = useWalletConnectStore();
  const { session, connect, disconnect, isInitializing } = useWalletConnectClient();

  //const handleConnect = () => {
    //connect();
  //};

  //const handleDisconnect = () => {
    //disconnect();
  //};

  /*return {
    session,
    selectedAccount,
    signingType,
    isInitializing,
    setSelectedAccount,
    setSigningType,
    handleConnect,
    handleDisconnect
  }*/
};

//performs the wallet connect
export const useWalletConnection = (providerId) => {
  const { handleConnect, handleDisconnect } = useWalletConnect();

  // Function to establish a connection with WalletConnect
  //const connectWithWalletConnect = async () => {
  //  handleConnect();
  //};

  // Now, connectWithWalletConnect can be called within a component
  //return { connectWithWalletConnect };
};

export default ConnectWithProvider;
