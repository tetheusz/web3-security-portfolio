// SPDX-License-identifier: MIT
pragma solidity ^0.8.30;

// A simple bank contract vulnerable to reentrancy attacks // not vulnerable anymore
contract SimpleBankVulnerable {
    
    // Stores the ETH balance of each user
    mapping(address => uint256) public balances;
    // State variable for the Mutex (lock)
    bool private locked; 
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // Modifier to Prevent Reentrancy
    modifier nonReentrant() {
        // If already locked (locked == true), revert immediately.
        require(!locked, "Reentrant call detected"); 
        // LOCK: Set the lock before proceeding
        locked = true; 
        // Execute the function's logic
        _; 
        // UNLOCK: Release the lock after execution is complete
        locked = false; 
    }

    // Deposit function
    function deposit() external payable {
        // 1. CHECKS
        require(msg.value > 0, "Deposit must be higher than 0");
        // 2. EFFECTS
        balances[msg.sender] += msg.value;
        // 3. INTERACTIONS (Log only)
        emit Deposit(msg.sender, msg.value);
    }
    
    // Secured Withdraw Function (Applying the nonReentrant Guard)
    function withdrawSecured(uint256 amount) external nonReentrant {
        // 1. CHECKS
        require(balances[msg.sender] >= amount, "Insufficient funds");
        // 2. EFFECTS (CEI) - Update the balance before the external interaction
        balances[msg.sender] -= amount;
        // 3. INTERACTIONS - External call is now safe because the lock is active.
        (bool success, ) = msg.sender.call{value: amount}(""); 
        require(success, "Transfer failed");
        emit Withdraw(msg.sender, amount);
    }
}