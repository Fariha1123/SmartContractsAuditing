pragma solidity ^0.4.23;


contract ERC20 {
    //Sets events and functions for ERC20 token
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event Transfer(address indexed _from, address indexed _to, uint _value);

    function allowance(address _owner, address _spender) public constant returns (uint remaining);
    function approve(address _spender, uint _value) public returns (bool success);
    function balanceOf(address _owner) public constant returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
}
