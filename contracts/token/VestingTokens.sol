pragma solidity ^0.4.23;

import "./LockedTokens.sol";

contract VestingTokens is LockedTokens {

    enum LOCK_TYPE {DEV, ADV, PRIV}

    uint public constant DEV_VEST_PERIOD_1 = 12 weeks;
    uint public constant DEV_VEST_PERIOD_2 = 1 years;
    uint public constant DEV_VEST_PERC_1 = 30;
    uint public constant DEV_VEST_PERC_2 = 70;

    uint public constant ADV_VEST_PERIOD_1 = 12 weeks;
    uint public constant ADV_VEST_PERIOD_2 = 1 years;
    uint public constant ADV_VEST_PERC_1 = 30;
    uint public constant ADV_VEST_PERC_2 = 70;

    uint public constant PRIV_VEST_PERIOD_1 = 12 weeks;
    uint public constant PRIV_VEST_PERIOD_2 = 1 years;
    uint public constant PRIV_VEST_PERC_1 = 30;
    uint public constant PRIV_VEST_PERC_2 = 70;

    constructor(IERC20 _token, address _crowdsaleAddress) public {
        mToken = _token;
        mCrowdsaleAddress = _crowdsaleAddress;
    }

    //divide this function with vesting type 
    function lockup(address _to, uint256 _amount, LOCK_TYPE _type) external {
        require(msg.sender == mCrowdsaleAddress);
        if(_type == LOCK_TYPE.DEV){
            super.addTokens(_to, _amount.mul(DEV_VEST_PERC_1).div(100), now + DEV_VEST_PERIOD_1);
            super.addTokens(_to, _amount.mul(DEV_VEST_PERC_2).div(100), now + DEV_VEST_PERIOD_2);
        } else if(_type == LOCK_TYPE.ADV){
            super.addTokens(_to, _amount.mul(ADV_VEST_PERC_1).div(100), now + ADV_VEST_PERIOD_1);
            super.addTokens(_to, _amount.mul(ADV_VEST_PERC_2).div(100), now + ADV_VEST_PERIOD_2);
        } else if(_type == LOCK_TYPE.PRIV){
            super.addTokens(_to, _amount.mul(PRIV_VEST_PERC_1).div(100), now + PRIV_VEST_PERIOD_1);
            super.addTokens(_to, _amount.mul(PRIV_VEST_PERC_2).div(100), now + PRIV_VEST_PERIOD_2);
        } else{
            revert("Worng Lock Type");
        }
    }

}