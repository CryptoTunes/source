module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: 5777
    },
    ropsten: {
      host: "localhost",
      port: 8545,
      network_id: 3,
      gas: 4000000
    },
    production: {
      host: "localhost",
      port: 8545,
      network_id: 1
    }
  }
};
