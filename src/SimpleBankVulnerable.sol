// SPDX-License-identifier: MIT
pragma solidity ^0.8.30;

contract SimpleBankVulnerable {

    //Stores ETH balances of each user
    mapping(address => uint256) public balances;

    //Simple Events 
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    function deposit() external payable {
        //Check if the value is greater than zero and receive ETH and log 
        require(msg.value > 0, "Insuficient funds" );
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
        function withdrawVulnerable(uint256 amount) external {
        // 1. CHECKS (Right)
        require(balances[msg.sender] >= amount, "Insufficient funds"); // 2. INTERACTION (DANGER!)
        (bool success, ) = msg.sender.call{value: amount}(""); 
        require(success, "Transfer failed"); // <-- Vulnerability!
        // 3. EFFECTS (DANGER!!)
        // The amount only changes after the transaction.
        balances[msg.sender] -= amount;
        emit Withdraw(msg.sender, amount);
    
    }
}