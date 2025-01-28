// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

// import {StdAssertions, stdAssertions} from "forge-std/StdAssertions.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        fundMe = (new DeployFundMe()).run();
        vm.deal(USER, STARTING_BALANCE);
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
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    // function testOnlyOwonerCanWithdraw() public {

    //     vm.prank(USER);
    //     fundMe.fund{ SEND_VALUE()};

    //     vm.prank(USER);
    //     vm.expectRevert();
    //     fundMe.withdraw();

    // }
}
