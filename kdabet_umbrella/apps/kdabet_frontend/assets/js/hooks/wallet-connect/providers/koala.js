const networkId = "mainnet01"
//const networkId = "testnet04"

const KoalaWallet = {
  /*window.addEventListener(`phx:connect-koala`, (e) => {*/
  name: "Koala",
  connect: async function() {
    console.log("here")
    /* Asyncronously make a wallet connect request to Koala Wallet */
    let accountResult = await window.koala.request({
      method: "kda_connect",
      networkId: networkId,
    });
    /* return result */ 
    return accountResult;
  },
  disconnect: async function() {
    /* Asyncronously make a wallet disconnect request to Koala Wallet */
    return await window.koala.request({
      method: "kda_disconnect",
      networkId: networkId,
    });    
  },
  fetch_account: async function(){
    /* Asyncronously make a get balance request to Koala Wallet */   
    let account = await window.koala.request({
      method: 'kda_requestAccount',
      networkId,
    });
    /*  return result */
    return account;
  },
  sign: async function(signingCommand) {
    /* Create a signing command, send it to Koala wallet
     * and return a signed transaction command */ 
    let req = {
      method: "kda_requestSign",
      networkId: networkId,
      data: {
        networkId: networkId,
        signingCmd: JSON.parse(signingCommand)
      }
    }

    console.log(req)
    var cmd = await window.koala.request(req);

    return cmd.signedCmd;
  },


  quickSign: async function(signingCommand) {
    /* Quick sign is a process that allows for intermiediary
    * partial transactions as a "test" to ensure a transaction
    * is not deleterious to the smart contract user
    *
    * It also allows for batched transactions in a single 
    * Signing
    *
    * The Quick Sign Kip:
    * https://github.com/kadena-io/KIPs/blob/master/kip-0015.md*/ 
    let networkId = 'mainnet01';
    const req = {
      method: "kda_requestQuickSign",
      networkId: networkId,
      data: {
        networkId: "mainnet01",
        commandSigDatas: [
          {
            sigs: signingCommand.signers, 
            cmd: JSON.stringify(signingCommand)
          }
        ]
      }
    }
    try {
      const cmd = await window.koala.request(req);
      return cmd;
    } catch (error) { 
      console.error("Error in Koala quick sign function:", error);
    }
  }
}

export default KoalaWallet
