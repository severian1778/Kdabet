const networkId = "mainnet01"

const EckoWallet = {
  /*window.addEventListener(`phx:connect-koala`, (e) => {*/
  name: "Ecko",
  connect: async function() {
    /* Asyncronously make a wallet connect request to Ecko Wallet */
    let accountResult = await kadena.request({
      method: "kda_connect",
      networkId: networkId
    });
    /* return result */ 
    return accountResult;
  },
  disconnect: async function() {
    /* Asyncronously make a wallet disconnect request to Ecko Wallet */
    return await kadena.request({
      method: "kda_disconnect",
      networkId: networkId
    });    
  },
  fetch_account: async function(){
    /* Asyncronously make a get balance request to Ecko Wallet */   
    let account = await kadena.request({
      method: 'kda_requestAccount',
      networkId
    });
    /*  return result */
    return account;
  }
}

export default EckoWallet
