pragma solidity ^0.4.23;

import "../node_modules/zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";

contract RecToken is PausableToken, BurnableToken {
  string public name;
  string public symbol;
  uint256 public decimals;
  uint256 public totalSupply;
  constructor(string _tokenName, string _tokenSymbol, uint8 _decimalUnits, uint256 _initialAmount, address _teamWallet, address _reservationWallet, address _bountyWallet) public {
    name = _tokenName;
    symbol = _tokenSymbol;
    decimals = _decimalUnits;
    totalSupply = _initialAmount;
    balances[msg.sender] = totalSupply * 20 / 100;

    mint(_teamWallet, totalSupply * 10 / 100);
    mint(_reservationWallet, totalSupply * 50 / 100);
    mint(_bountyWallet, totalSupply * 20 / 100);
  }

  function mint(address _to, uint _amount) internal {
    balances[_to] = balances[_to].add(_amount);
  }
}
