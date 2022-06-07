module.exports = {
  contracts_directory: './contracts/',
  contracts_build_directory: './assets/contracts_abis/',
  networks: {
    development: {
      host: "192.168.1.26",
      port: 7545,
      network_id: "*"
    }
  },
  compilers: {
    solc: {
      version: "0.8.14",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
