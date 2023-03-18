require("dotenv").config({ path: '../.env' })
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.18",
    defaultNetwork: process.env.NETWORK,
    networks: {
        "goerli": {
            url: process.env.GOERLI_NODE_URL || "",
            accounts: [process.env.WALLET_PRIVATE_KEY]
        },
        "mantle-testnet": {
            url: "https://rpc.testnet.mantle.xyz/",
            accounts: [process.env.WALLET_PRIVATE_KEY]
        }
    },
};
