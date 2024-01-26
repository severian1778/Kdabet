const networkId = "mainnet01"
/*const networkId = "testnet04"*/

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
  },
  sign: async function(signingCommand) {
    let req = {
      method: "kda_requestSign",
      networkId: networkId,
      data: {
          networkId: networkId,
          signingCmd: JSON.parse(signingCommand)
      }
    }
    var cmd = await window.kadena.request(req);
    return cmd;
  }
}

export default EckoWallet
