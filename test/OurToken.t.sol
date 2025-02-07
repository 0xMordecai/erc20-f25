// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    uint256 public constant STARTING_BALANCE = 100 ether;

    address messi = makeAddr("messi");
    address ronaldo = makeAddr("ronaldo");

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(messi, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(messi));
    }

    function testAllowancesWorks() public {
        // transferFrom
        uint256 initialAllowances = 1000;

        // messi approves Alice to spend tokens on his behalf
        vm.prank(messi);
        ourToken.approve(ronaldo, initialAllowances);

        uint256 tranferAmount = 500;

        vm.prank(ronaldo);
        ourToken.transferFrom(messi, ronaldo, tranferAmount);

        assertEq(ourToken.balanceOf(ronaldo), tranferAmount);
        assertEq(ourToken.balanceOf(messi), STARTING_BALANCE - tranferAmount);
    }
}
