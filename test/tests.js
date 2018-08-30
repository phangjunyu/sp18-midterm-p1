'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Token = artifacts.require("./Token.sol");
// YOUR CODE HERE

contract('Crowdsale Test', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */
	const args = {};
	let crowdSale, token;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		// YOUR CODE HERE
		crowdsale = await Crowdsale.new();
	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Contract Functionality', function() {
		it("Token.sol has been deployed", async function() {
			// YOUR CODE HERE
			assert(tokenContract.deployed());
		});
		it("Keeps track of how many tokens have been sold", async function() {
			// YOUR CODE HERE
		});

		it("Only sells to/refunds buyers during sale time", async function(){

		});

		it("forwards funds to owner after sale is over", async function(){

		});
	});

	describe('Token Functionality', function() {
		// YOUR CODE HERE
	});
});
