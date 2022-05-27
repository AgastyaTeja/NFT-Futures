require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

// Possible network values
const TEST_NETWORK = "TEST_NETWORK";
const LOCAL_NETWORK = "LOCAL_NETWORK";
// By default network is set to local, change it to TEST_NETWORK to make a switch
const NETWORK = TEST_NETWORK;

// const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
// const WALLET_PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY;
// const INFURA_API_KEY = process.env.INFURA_ID

const ALCHEMY_API_KEY = 'zYQ9OjPTGl6lcSthY0w-kZZrVNA-EBRd' //process.env.ALCHEMY_API_KEY;
const WALLET_PRIVATE_KEY = '93217498a8d2429fc9b7848da6994b6bf26fa328606a8b8c433d0575d4cffd8d' //process.env.WALLET_PRIVATE_KEY;
const INFURA_API_KEY = '9282b715ab934b08bc2e6eacf20e889f' //process.env.INFURA_ID


console.log(ALCHEMY_API_KEY)
console.log(WALLET_PRIVATE_KEY)

let networks = {};
if (NETWORK == TEST_NETWORK) {  
  networks = {
    rinkeby: {      
      // url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      url: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [`0x${WALLET_PRIVATE_KEY}`]
    }
  }
}
// console.log(networks);
module.exports = {
  solidity: "0.8.1",
  networks: networks
};