pragma solidity 0.4.24;

import './Queue.sol';
import './Token.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	// YOUR CODE HERE
	//variables
	uint256 amountSold;
	uint256 timeStart;
	uint256 timeEnd;
	Queue queue;
	Token myToken;
	address owner;

	//constructor
	constructor(){
		owner = msg.sender;
		queue = Queue();
		myToken = Token();
	}

	//Events

	//modifiers
	modifier onlyOwner{
		require(msg.sender == owner, "this function is owner only");
		_;
	}

	modifier withinTime{
		require(now >= timeStart && now <= timeEnd);
		_;
	}

	function setTimes(uint256 startTime, uint256 endTime) public onlyOwner {
		startTime = startTime;
		endTime = endTime;
	}

	function setInitialAmount(uint256 amount) public onlyOwner {

	}

	function mintNewTokens(uint256 amount) public onlyOwner{

	}

	function burnUnSoldTokens(uint256 amount) public onlyOwner{

	}

	function setTokenPrice(uint256 rate) public onlyOwner{
		//rate is the amount of tokens to be exchanged for 1 wei
	}

	function buyToken() payable withinTime{
		require(msg.sender == queue.getFirst() && queue.qsize() > 1);
		uint256 amount = msg.value/myToken.tokenPrice;
		myToken.transfer(msg.sender, amount);
	}
}
