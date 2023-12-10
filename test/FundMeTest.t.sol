//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    HelperConfig public helperConfig;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
         (fundMe, helperConfig) = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testFundFailsWithoutEnoughETH() public{
        vm.expectRevert();
        fundMe.fund(); // we don't send any value here
        //fundMe.fund{value:2500000000000000000000}();  // We send more than the minimum required amount so it should not revert
    }
    

    function testOwnerIsMsgSender() public {
        assertEq(msg.sender, fundMe.i_owner());
    }
}
