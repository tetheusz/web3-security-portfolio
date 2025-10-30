// SPDX-License-identifier: MIT
pragma solidity ^0.8.30;

contract SimpleBank {

    //Stores ETH balances of each user
    mapping(address => uint256) public balances;

    //Simple Events 
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    function deposit() external payable {
        //Check if the value is greater than zero and receive ETH and log 
        require(msg.value > 0, "Deposit must be higher than 0" );
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
        function withdraw(uint256 amount) external {
        //Check if the value of withdraw is equal or higher than the balace, withdraw ETH and log
            require(balances[msg.sender] >= amount, "Insufficient funds");
            balances[msg.sender] -= amount;
            payable(msg.sender).transfer(amount);
            emit Withdraw(msg.sender, amount);
        }
    }
