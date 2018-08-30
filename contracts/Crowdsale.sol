pragma solidity 0.4.24;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	// YOUR CODE HERE
	using SafeMath for uint256;
	//variables
	uint256 timeStart;
	uint256 timeEnd;

	uint256 amountSold;

	uint256 tokenRate; //for 1 wei
	Token public myToken;

	address public owner;
	Queue public queue;

	//constructor
	constructor() public {
		owner = msg.sender;
		amountSold = 0;
		/* queue = Queue();
		myToken = Token(); */
	}

	//Events
	event TokenPurchased(uint256 _amount);
	event TokenRefunded(uint256 _amount);

	//modifiers
	modifier onlyOwner{
		require(msg.sender == owner, "this function is owner only");
		_;
	}

	modifier withinTime{
		require(now >= timeStart && now <= timeEnd);
		_;
	}

	function setTimes(uint256 startTime, uint256 endTime) public view onlyOwner {
		startTime = startTime;
		endTime = endTime;
	}

	function checkTime() public onlyOwner returns (uint256 timeLeft) {
		if (now < timeEnd)
			timeLeft = timeEnd - now;
		else {
			timeLeft = 0;
			endContract();
		}
	}

	function setInitialAmount(uint256 amount) public onlyOwner {
		require(now <= timeStart, "initial amount has to be set before crowdsale starts");
		myToken.setTokenSupply(amount);
	}

	function mintNewTokens(uint256 amount) public view onlyOwner withinTime{
		require(amount >= 0);
		assert(myToken.addToken(amount));
	}

	function burnUnSoldTokens(uint256 amount) public view onlyOwner withinTime{
		require(amount >= 0 && amount <= myToken.totalSupply());
		assert(myToken.subtractToken(amount));
	}

	function setTokenPrice(uint256 rate) public onlyOwner{
		//rate is the amount of tokens to be exchanged for 1 wei
		require(rate > 0 && now < timeStart);
		tokenRate = rate;
	}

	function buyToken() public payable withinTime{
		require(msg.sender == queue.getFirst() && queue.qsize() > 1);
		uint256 amount = msg.value.div(tokenRate);
		assert(msg.value >0);
		myToken.transfer(msg.sender, amount);
		amountSold = amountSold.add(amount);
		emit TokenPurchased(amount);
	}

	function refundToken() public payable withinTime{

		amountSold = amountSold.sub(msg.value);
		msg.sender.transfer(msg.value.mul(tokenRate));
		emit TokenRefunded(msg.value);
	}

	function joinQueue() public withinTime{
		queue.enqueue(msg.sender);
	}

	function endContract() private {
		selfdestruct(owner);
	}
}
