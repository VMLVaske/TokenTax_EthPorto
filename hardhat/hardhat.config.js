require("dotenv").config()
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  defaultNetwork: process.env.NETWORK,
    networks: {
        goerli: {
            url: process.env.GOERLI_NODE_URL || "",
            accounts: [process.env.WALLET_PRIVATE_KEY]
        },
        mainnet: {
            url: process.env.MAINNET_NODE_URL || "",
            accounts: [process.env.WALLET_PRIVATE_KEY],
        },
    },
};
