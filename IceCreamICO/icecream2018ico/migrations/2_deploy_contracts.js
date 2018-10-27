/* eslint-disable */
const RecToken = artifacts.require("./RecToken.sol");
const RecTokenCrowdsale = artifacts.require("./RecTokenCrowdsale.sol");

module.exports = function(deployer) {
  // Parametrs:
  // - beginning of ICO
  // - end of ICO
  // - rate
  // - hardcap
  // - wallet
  // - token address

  return deployer
  .then(() => {
      return deployer.deploy(
        RecToken,
        "REC COIN", // TOKEN Name
        "REC", // Token Symbol
        18, // Token Decimal
        10E26, // total token amount
        '0x4935fd60533daf36800608df59c9e27f349e5266', // Team Wallet Address
        '0x0dfbf0c243cc5e4bb57eb4bdebf821b3e8915afc', // Reservation Wallet Address
        '0x7d6de35ea8998c8a80f902d92159a6805123bbfc', // Bounty Wallet Address
      );
  })
  .then(() => {
      return deployer.deploy(
        RecTokenCrowdsale,
        // Math.round(1531465200000/1000.0), // ICO start 2018-07-13 14:00 pm
        Math.round(1533110400000/1000.0), // ICO start 2018-08-01 09:00 London Time
        Math.round(1538348340000/1000.0), // ICO end 2018-09-30 23:59 London Time
        1000, // Token Rate
        2E26, // HardCap
        '0x4085db657e063d64f9ce2785e625d99a9240264b', //ICO Wallet Address
        RecToken.address
      );
  });
};
