/* global artifacts: true */
var CryptoTunes = artifacts.require('CryptoTunes');

module.exports = function(deployer) {
  deployer.deploy(CryptoTunes);
};
