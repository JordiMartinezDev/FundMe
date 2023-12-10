//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    HelperConfig public helperConfig;
    address  USER = makeAddr("user");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
         (fundMe, helperConfig) = deployFundMe.run();
         vm.deal(USER,100 ether);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testFundFailsWithoutEnoughETH() public{
        vm.expectRevert();
        fundMe.fund(); // we don't send any value here
        //fundMe.fund{value:2500000000000000000000}();  // We send more than the minimum required amount so it should not revert
    }
    
    function testFundUpdatesFundedDataStructure() public{
        vm.prank(USER); // we set the next TX msg.sender as USER, so we fake/prank who is sending the transactions
        fundMe.fund{value:10 ether}(); // we send 1 eth
        uint amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,10 ether);

    }

    function testAddsFunderToArrayOfFunders() public{
        // Testing 1 user funds and is added correctly to the array
        vm.prank(USER);
        fundMe.fund{value:1 ether}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
        // Testing 2nd user funds and is added correctly
         vm.prank(USER);
        fundMe.fund{value:1 ether}();
        funder = fundMe.getFunder(1);
        //Testing no other funders are in the array, so expect recvert upon checking more funders
        assertEq(funder, USER);
        vm.expectRevert();
        funder = fundMe.getFunder(2);

    }

    function testOwnerIsMsgSender() public {
        assertEq(msg.sender, fundMe.i_owner());
    }
}
