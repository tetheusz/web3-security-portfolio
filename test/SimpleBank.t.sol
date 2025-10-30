// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "src/SimpleBank.sol";

contract SimpleBankTest is Test {

    SimpleBank bank;
    address user = address(0x1234);

    function setUp() public{
        bank = new SimpleBank();
        vm.deal(user, 10 ether);
    }

    function testDeposit() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();
        assertEq(bank.balances(user), 1 ether);
    }

    function testDeposit0() public {
    vm.prank(user);
    vm.expectRevert("Deposit must be higher than 0");
    bank.deposit{value: 0}();
    }

     function testWithdraw() public {
        vm.prank(user);
        bank.deposit{value: 1 ether}();
        vm.prank(user);
        bank.withdraw(1 ether);
        assertEq(bank.balances(user), 0);
    }

     function testWithdrawFailsIfInsufficient() public {
        vm.prank(user);
        vm.expectRevert(bytes("Insufficient funds"));
        bank.withdraw(1 ether);
    }
}
