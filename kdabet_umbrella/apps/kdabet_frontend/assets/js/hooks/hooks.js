import WalletConnect from "./wallet_listen.js"
import ConnectWithProvider from "./connect_with_provider.js"
/* Provider Scripts*/
import KoalaWallet from "./wallet-connect/providers/koala.js"
import EckoWallet from "./wallet-connect/providers/ecko.js"
import ZelcoreWallet from "./wallet-connect/providers/zelcore.js"

let Hooks = {
  WalletConnect: WalletConnect,  /* Methods for listening for wallet messages*/
  ConnectWithProvider: ConnectWithProvider,
  KoalaWallet: KoalaWallet,
  EckoWallet: EckoWallet,
  ZelcoreWallet: ZelcoreWallet
}

export default Hooks
