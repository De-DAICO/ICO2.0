/* All constants used in other contracts are defined here.
*/
pragma solidity ^0.4.23;

contract Param {
    /* Token */
        uint8 public constant DECIMALS = 18;
        uint public constant INITIAL_SUPPLY = 100 * (1000 ** 3) * (10 ** uint256(DECIMALS));
        string public constant TOKEN_NAME = "CUSTOM";
        string public constant TOKEN_SYMBOL = "CTM";
    
    /* Crowdsale */

        uint public constant HARD_CAP = 37500 ether;
        uint public constant MIN_CONTRIB = 5000 ether;

        //percentage of tokens total : 1000%
        uint public constant PUB_TOKEN_PERC = 200;
        uint public constant PRIV_TOKEN_PERC = 200;
        uint public constant DEV_TOKEN_PERC = 140;
        uint public constant ADV_TOKEN_PERC = 50;
        uint public constant RESERVE_TOKEN_PERC = 200;
        uint public constant REWARD_TOKEN_PERC = 200;
        uint public constant INCENTIVE_TOKEN_PERC = 10;

        //limitation of public participants
        uint public constant ETHER_MIN_CONTRIB = 1 ether;
        uint public constant ETHER_MAX_CONTRIB = 300 ether;

        //crowd sale time
        uint public constant SALE_START_TIME = 0;
        uint public constant SALE_END_TIME = 0;

        // how many token units a buyer gets per wei
        uint public constant DEFAULT_RATE = 50*10**5; //this is ether/token or wei/tokenWei

    /* Fund */


        uint public constant INITIAL_TAP = 0.01 ether; //(0.01 ether/sec)
        uint public constant DEV_VESTING_PERIOD = 1 years;

    /* Pool */


        uint256 public constant MIN_RECEIVABLE_TOKEN = 100; // minimum token holdings
        // HARD_CAP // derived from Crowdsale

    /* Voting */


        uint256 public constant MIN_TERM = 7 days; // possible term of minimum tap voting
        uint256 public constant MAX_TERM = 2 weeks; // possible term of maximum tap voting
        uint256 public constant DEV_POWER = 700; // voting weight of developers (max: 1000%)
        // DEV_TOKEN_PERC // derived from Crowdsale
        uint256 public constant PUBLIC_TOKEN_PERC = 65; //FIXIT: it should be changed in every tap voting term and it is NOT constant, it means totalSupply() - locked_token - reserve_token
        uint256 public constant REFRESH_TERM = 4 weeks; // refresh term of refund voting
}