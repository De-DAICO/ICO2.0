/*
 * This contract is about manipulating funded ether.
 * After DAICO, funded ether follows this contract.
 */

pragma solidity ^0.4.21;

import "../token/ERC20.sol";
import "../token/IERC20.sol";
import "../crowdsale/Crowdsale.sol";
import "../ownership/Ownable.sol";
import "../lib/SafeMath.sol";

contract Fund is Ownable, IERC20 {
    using SafeMath for uint256;
    enum FUNDSTATE {
        BEFORE_SALE,
        CROWDSALE,
        WORKING,
        LOCKED,
        COLLAPSED
    }
    /*Constants*/
    uint256 public constant INITIAL_TAP = 0.01 ether; //(0.01 ether/sec)
    uint256 public constant DEV_VESTING_PERIOD = 1 years;
    
    /*Global variables*/
    // totalEther = [contract_account].balance
    FUNDSTATE public state;
    IERC20 public token;
    address public teamWallet; // no restriction for withdrawing
    uint256 public tap;
    address public votingFactoryAddress;
    uint256 public retapVotingStartTime; // term that the new tap voting is able to restart
    IncentivePool inc_pool;

    /*Modifiers*/
    modifier period(FUNDSTATE _state) {
        require(state == _state);
        _;
    }

    /*Events*/
    event CreateFund(address indexed token_address, address indexed team_wallet, address creator);
    //add more

    /*Constructor*/
    function Fund(address _token, address _teamWallet) public onlyDevelopers {
        token = IERC20(_token);
        teamWallet = _teamWallet;
        state = FUNDSTATE.BEFORE_SALE;
        inc_pool = new IncentivePool();
        tap = INITIAL_TAP;
        emit CreateFund(token, teamWallet, msg.sender);
    }

    /*view function*/
    function getVestingRate() view public returns(uint256) {
        uint256 term = SafeMath.safeSub(now, startTime); // is the unit same?
        return SafeMath.safeDiv(term, DEV_VESTING_PERIOD);
    }
    function getState() view public returns(FUNDSTATE) { return state; }
    function getToken() view public returns(IERC20) { return token; }
    function getTeamWallet() view public returns(address) { return teamWallet; }
    function getTap() view public returns(uint256) { return tap; }
    function getVotingFactoryAddress() view public returns(address) { return votingFactoryAddress; }
    function getIncentivePool() view public returns(IncentivePool) { return inc_pool; }

    /*set function*/
    function setTap(uint256 rate) external returns(bool){
        tap = SafeMath.safeMul(tap, rate);
    }
    function setVotingFactoryAddress(address _votingfacaddr) external onlyDevelopers{ 
        require(_votingfacaddr != 0x0);
        votingFactoryAddress = _votingfacaddr; 
    }
    
    /*fallback function*/
    function () external payable {}

    /*state function*/
    function startSale() external period(FUNDSTATE.BEFORE_SALE) {}
    function finalizeSale() external period(FUNDSTATE.CROWDSALE) {}
    function dividePoolAfterSale() external period(FUNDSTATE.WORKING) payable {
    //TODO: divide ETH into incentive pool(1%) and others.
    }
    /*tap function*/
    function increaseTap(uint256 change) external period(FUNDSTATE.WORKING) {}
    function decreaseTap(uint256 change) external period(FUNDSTATE.WORKING) {}

    /*withdraw function*/
    function withdrawFromFund() external onlyDevelopers period(FUNDSTATE.WORKING) payable {}

    /*lock function*/
    function lockFund() external period(FUNDSTATE.WORKING) {}

    /*refund function*/
    function refund() external period(FUNDSTATE.LOCKED) {}
}
