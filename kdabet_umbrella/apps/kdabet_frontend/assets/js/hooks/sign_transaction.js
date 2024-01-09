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
const SignTransaction = async (providerId, transaction) => {
  console.log(transaction)
  let provider = fetch_provider(providerId);
  let signTransactionResult

  try {
    console.log("megan")
    signTransactionResult = await provider.sign(transaction);
    console.log("rides")
    console.log(signTransactionResult)
    return 
  }catch(e){
    console.log("Error signing transaction:", e);
  }
}

export default SignTransaction;
