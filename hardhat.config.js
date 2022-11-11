/** @type import('hardhat/config').HardhatUserConfig */
require('hardhat-abi-exporter');


module.exports = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  paths:{
    sources: 'lib/src/generated/'
  },
  abiExporter: 
  [
    {
      path: 'lib/src/generated/abi/',
      runOnCompile: true,
      // clear: true,
      // flat: true,
      only: [':IERC20$'],
      rename: () => 'IERC20.abi',
      spacing: 2,
      // pretty: true,
      format: "json",
    },
  ],
};
