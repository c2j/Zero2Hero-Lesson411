//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;

// We import this library to be able to use console.log
import "hardhat/console.sol";


// This is the main building block for smart contracts.
contract TokenImpl {
    // Some string type variables to identify the token.
    string public name = "AIGC Token";
    string public symbol = "AIGC";
    uint256 public constant VERSION = 2;

    bool public initialized;

    // The fixed amount of tokens stored in an unsigned integer type variable.
    //uint256 public totalSupply = 1000000000; // One Billion

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // A mapping is a key/value map. Here we store each account balance.
    mapping(address => uint256) balances;

    

    // The Transfer event helps off-chain aplications understand
    // what happens within your contract.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * Contract initialization.
     */
    // constructor() {
    //     // The totalSupply is assigned to the transaction sender, which is the
    //     // account that is deploying the contract.
    //     balances[msg.sender] = totalSupply;
    //     owner = msg.sender;
    // }

    // 按第四课的要求进行修改，本合约作为逻辑合约，不应该有构造函数，所以上面的constructor会被注释掉
    // 以下面的代理-逻辑合约模式实现：
    modifier initializer(){
        require(!initialized, "Only initialize once");
        _;
        initialized = true;
    }

    function initialize(uint256 argTotalSupply) public initializer{
        owner = msg.sender;
        balances[owner] = argTotalSupply;
    }


    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from outside
     * the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");
        require(msg.sender != to, "Could not be same account");

        // We can print messages and values using console.log, a feature of
        // Hardhat Network:
        console.log(
            "Transferring from %s to %s %s tokens",
            msg.sender,
            to,
            amount
        );

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    /**
     * 
     */
    function totalSupply() external view returns (uint256) {
        return balances[owner];
    }
}
