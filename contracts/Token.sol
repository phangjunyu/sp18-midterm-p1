pragma solidity 0.4.24;

import './interfaces/ERC20Interface.sol';
import './utils/SafeMath.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE
    using SafeMath for uint256;
	/// total amount of tokens
    uint256 public totalSupply;
    bool private hasOwnerSetup;
    mapping(address => uint256) balances;
    //maps the approver to the approved and the balance that the approved has
    mapping(address => mapping(address => uint256)) allowed;

    constructor() public {
        hasOwnerSetup = false;
    }

    function setTokenSupply(uint256 _initialAmount) public returns (bool success){
        require(!hasOwnerSetup);
        totalSupply = _initialAmount;
        hasOwnerSetup = true;
        return hasOwnerSetup;
    }

    //public getter
    function totalSupply()
        public
        view
        returns (uint256 total){
            return totalSupply;
        }

    //public setter for token
    function addToken(uint256 amount)
        public
        view
        returns (bool success){
            totalSupply.add(amount);
            return true;
        }
    //public setter for token
    function subtractToken(uint256 amount)
        public
        view
        returns (bool success){
            totalSupply.sub(amount);
            return true;
        }

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner)
        public
        view
        returns (uint256 balance) {
            return balances[_owner];
    }
    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value)
        public
        returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value)
        public
        returns (bool success){
            if (allowance(_from, _to) >= _value){
                allowed[_from][_to] = allowed[_from][_to].sub(_value);
                return transfer(_to, _value);
            } else return false;

    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value)
    public
    returns (bool success){
        require(_value >= 0);
        allowed[msg.sender][_spender]=_value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining){
        return allowed[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
