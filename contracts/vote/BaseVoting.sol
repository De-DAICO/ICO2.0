pragma solidity ^0.4.21;

import "../ownership/Ownable.sol";
import "../token/BaseToken.sol";
import "../token/Fund.sol";
import "../lib/SafeMath.sol";

contract BaseVoting is Ownable, BaseToken {
    using SafeMath for uint256;

    string public votingName;
    bool public isInitialized = false;
    bool public isFinalized = true;
    bool public isOpened = false;
    uint256 public startTime;
    uint256 public endTime;
    
    uint256 public total_party = 0;
    uint256 public agree_party = 0;
    uint256 public disagree_party = 0;

    enum VOTESTATE {NONE, AGREE, DISAGREE}
    mapping(address=>VOTESTATE) public party_list;
    mapping(address=>uint256) public revoke_list; //account=>revoke count

    /* EVENTS */
    event InitializeVote(address indexed vote_account, string indexed voting_name, uint256 startTime, uint256 endTime);
    /* CONSTRUCTOR */
    function BaseVoting(string _votingName) public {
        votingName = _votingName;
    }
    /*VIEW FUNCTION*/
    function isActivated() public view returns(bool) {
        return (isOpened);
    }
    function getInfo() public view returns(struct); //TODO
    function getName() public view returns(string){
        return votingName;
    }

    /*FUNCTION*/

    //initialize -> open -> close -> finalize
    function initialize(uint term) public returns(bool) {
        require(!isInitialized && isFinalized);
        startTime = now;
        endTime = now + term; // you should change the alpha into proper value.
        emit InitializeVote(address(this), votingName, startTime, endTime);
        isInitialized = true;
        isFinalized = false;
        return true;
    }

    function openVoting() public returns(bool){
        require(!isOpened && isInitialized);

        isOpened = true;
        isInitialized = false;
        return true;
    }

    function closeVoting() public returns(bool){
        require(isOpened);

        isOpened = false;
        return true;
    }

    function finalize() public returns(bool){
        require(!isFinalized && !isOpened);

        isFinalized = true;
        return true;
    }

    function vote() public returns(bool agree) { 
        require(msg.sender != 0x0);
        require(!party_list[msg.sender]||party_list[msg.sender] == VOTESTATE.NONE); // can vote only once
        uint votePower = balanceOf[msg.sender];
        if(agree) {
            party_list[msg.sender] = VOTESTATE.AGREE;
            agree_party += votePower;
            total_party += votePower;
        }
        else {
            party_list[msg.sender] = VOTESTATE.DISAGREE;
            disagree_party += votePower;
            total_party += votePower;
        }
    }
    function revoke() public returns(bool) {
        require(msg.sender != 0x0);
        require(party_list[msg.sender] != VOTESTATE.NONE); // can vote only once
        uint256 memory votePower = 0.5**revoke_list[msg.sender];
        //add sender to revoke_list(or count up)
        if(revoke_list[msg.sender] > 0) { revoke_list[msg.sender]++; }
        else { revoke_list[msg.sender] = 1; }
        //subtract the count that sender voted before
        if(party_list[msg.sender] == VOTESTATE.AGREE){
            agree_party -= votePower;
            total_party -= votePower;
        }
        else if(party_list[msg.sender] == VOTESTATE.DISAGREE) {
            disagree_party -= votePower;
            total_party -= votePower;
        }
        //change the voter's state to NONE.
        party_list[msg.sender] = VOTESTATE.NONE;
        return true;
    }

    function _clearVariables() public returns(bool); // clean vars after finalizing prev voting.
    function destroy() external onlyDevelopers returns(bool){
        require(isFinalized);
        selfdestruct(address(this));
        return true;
    }
}



