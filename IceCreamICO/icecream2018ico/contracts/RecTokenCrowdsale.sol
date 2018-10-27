
pragma solidity ^0.4.23;

import "./RecToken.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";
contract RecTokenCrowdsale is CappedCrowdsale, TimedCrowdsale, Ownable {
    // ICO Stage, we have two stage - week1, week2
    struct Stage {
        uint256 id;
        uint256 start;                 // Stage start 
        uint256 duration;              // Duration of ICO stage
        uint256 rate;                  // Token value in current stage
        uint256 minInvestment;         // minInvestment of ether amount in current stage
        uint256 timeBonus;             // Time bonus in current stage
        uint256 smallBonus;            // Volume bonus 1 (small)
        uint256 mediumBonus;           // Volume bonus 2 (medium)
        uint256 heavyBonus;            // Volume bonus 3 (heavy)
        uint256 superBonus;            // Volume bonus 4 (super)
        uint256 sold;                  // Token sold amount in current stage
        uint256 amountInvestments;     // Wei Raise in current stage
        mapping (address => uint) investments;   // Map of investment address => wei amount
    }

    Stage public week1;
    Stage public week2;
    Stage public other;
    uint256 constant decimals = 1E18;
    struct Addr {
        address addr;
        uint amount;
    }
    RecToken public token;
    mapping (uint => Addr) public addresses;     // Founders, team wallet address
    
    constructor(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, RecToken _token) public
    CappedCrowdsale(_cap)
    TimedCrowdsale(_startTime, _endTime)
    Crowdsale(_rate, _wallet, _token)
    {
        week1 = Stage({
            id: 0,
            start: _startTime,                   // week1
            duration: 7 * 24 * 1 hours,          // 7 days = 168 hours
            rate: 1E22,                          // 1 ETH = 10000 REC
            minInvestment: 1E17,                 // min invest 0.1 ETH;
            timeBonus: 10,                       // 10% for people buying in week1
            smallBonus: 5,                       // 5% for people investing more or equal to 5 ETH 
            mediumBonus: 10,                     // 10% for people investing more or equal to 10 ETH 
            heavyBonus: 15,                      // 15% for people investing more or equal to 15 ETH
            superBonus: 20,                      // 20% for people investing more or equal to 20 ETH
            sold: 0,
            amountInvestments: 0
        });
        week2 = Stage({
            id: 1,
            start: _startTime + 7 * 24 * 1 hours, // week2
            duration: 7 * 24 * 1 hours,           // 7 days = 168 hours
            rate: 1E22,                           // 1 ETH = 10000 REC
            minInvestment: 1E17,                  // min invest 0.1 ETH;
            timeBonus: 5,                         // 5% for people buying in week2
            smallBonus: 5,                        // 5% for people investing more or equal to 5 ETH 
            mediumBonus: 10,                      // 10% for people investing more or equal to 10 ETH 
            heavyBonus: 15,                       // 15% for people investing more or equal to 15 ETH
            superBonus: 20,                       // 20% for people investing more or equal to 20 ETH
            sold: 0,
            amountInvestments: 0
        });
        other = Stage({
            id: 2,
            start: _startTime + 14 * 24 * 1 hours,  // other
            duration: 7 * 24 * 1 hours,             // 7 days = 168 hours
            rate: 1E22,                             // 1 ETH = 10000 REC
            minInvestment: 1E17,                    // min invest 0.1 ETH;
            timeBonus: 0,                           // 5% for people buying in week2
            smallBonus: 5,                          // 5% for people investing more or equal to 5 ETH 
            mediumBonus: 10,                        // 10% for people investing more or equal to 10 ETH 
            heavyBonus: 15,                         // 15% for people investing more or equal to 15 ETH
            superBonus: 20,                         // 20% for people investing more or equal to 20 ETH
            sold: 0,
            amountInvestments: 0
        });
        token = RecToken(_token);
    }

    /**
    * Define Stage
    */
    function definitionStage() internal view returns(Stage) {
        if (now >= week1.start && now < (week1.start + week1.duration)) {
            return week1;
        } else if (
            now >= week2.start &&
            now <= (week2.start + week2.duration)
        ) {
            return week2;
        } else {
            return other;
        }
    }

    function _getTokenAmount(uint256 _weiAmount)
        internal view returns (uint256)
    {   

        uint256 tokens = _weiAmount.mul(decimals).div(1 ether).mul(currentStage.rate);
        Stage memory currentStage = definitionStage();

        // Time Bonus
        if (currentStage.id == 0 || currentStage.id == 1) {
            tokens = tokens.add(tokens.div(currentStage.timeBonus));
        }
        // Volum based bonus
        if (_weiAmount >= 20 ether) {
            tokens = tokens.add(tokens.mul(currentStage.superBonus).div(100));
        } 
        else if (_weiAmount >= 15 ether) {
            tokens = tokens.add(tokens.mul(currentStage.heavyBonus).div(100));
        }
        else if (_weiAmount >= 10 ether) {
            tokens = tokens.add(tokens.mul(currentStage.mediumBonus).div(100));
        }
        else if (_weiAmount >= 5 ether) {
            tokens = tokens.add(tokens.mul(currentStage.smallBonus).div(100));
        }

        // Couting
        if (currentStage.id == 0) {
            week1.sold = week1.sold.add(tokens);
            week1.investments[msg.sender] = week1.investments[msg.sender].add(_weiAmount);
            week1.amountInvestments = week1.amountInvestments.add(_weiAmount);
        } 
        else if (currentStage.id == 1){
            week2.sold = week2.sold.add(tokens);
            week2.investments[msg.sender] = week2.investments[msg.sender].add(_weiAmount);
            week2.amountInvestments = week2.amountInvestments.add(_weiAmount);
        }
        else {
            other.sold = other.sold.add(tokens);
            other.investments[msg.sender] = other.investments[msg.sender].add(_weiAmount);
            other.amountInvestments = other.amountInvestments.add(_weiAmount);
        }
        return tokens;
    }
}   