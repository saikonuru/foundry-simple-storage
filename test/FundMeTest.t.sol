// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

// import {StdAssertions, stdAssertions} from "forge-std/StdAssertions.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() public {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        fundMe = (new DeployFundMe()).run();
    }

    function test_MinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum dollar is not five");
    }

    function testOwnerIsMsgSender() public view {
        console.log("address", address(this));
        // assertEq(fundMe.i_owner(), address(this));
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        assertEq(
            fundMe.getVersion(),
            4,
            "Version should match with contract deployed"
        );
    }
}
