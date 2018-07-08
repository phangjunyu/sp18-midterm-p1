pragma solidity 0.4.24;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	// YOUR CODE HERE
	uint8 size = 5;
	uint8 first;
	uint8 last;
	mapping(uint256 => Buyer) queue;
	uint8 time;
	struct Buyer{
		address add;
		uint256 timeStart;
	}


	/* Add events */
	// YOUR CODE HERE

	/* Add constructor */
	// YOUR CODE HERE
	constructor() public{
		first = 1;
		last = 0;
		time = 15; //can only be first in line for 15 seconds
	}

	/* Returns the number of people waiting in line */
	function qsize() public view returns(uint8) {
		// YOUR CODE HERE
		return last - first;
	}

	/* Returns whether the queue is empty or not */
	function empty() public view returns(bool) {
		// YOUR CODE HERE
		return (first <= last);
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() public view returns(address) {
		// YOUR CODE HERE
		require (!this.empty(), "queue is empty");
		return queue[first].add;
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() public view returns(uint8) {
		// YOUR CODE HERE
		require (!this.empty(), "queue is empty");
		for (uint8 i = first; i <= last; i++){
			if (queue[i].add == msg.sender)
				return i;
			require(i != last, "Your address is not in queue.");
		}
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() public {
		// YOUR CODE HERE
		if (queue[first].timeStart < now-15){
			this.dequeue();
		}
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() public {
		// YOUR CODE HERE
		require(!this.empty(), "queue is empty"); //not empty queue
		delete(queue[first]);
		first += 1;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) public {
		// YOUR CODE HERE
		require(last - first < 5, "queue has maximum limit of 5.");
		last += 1;
		queue[last].add = addr;
		queue[last].timeStart = now;
	}
}
