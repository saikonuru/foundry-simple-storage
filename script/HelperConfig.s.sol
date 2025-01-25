// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mock/MockV3Aggregator .sol";
import {Test, console} from "forge-std/Test.sol";

contract HelperConfig is Test {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainEthConfig();
        } else {
            // *! default  Anvi local // block.chainid = 31337
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return config;
    }

    function getMainEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return config;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // return config;
        // 1. Deploy the mocks
        // 2. Return mock

        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory config = NetworkConfig({priceFeed: address(mock)});
        return config;
    }
}
