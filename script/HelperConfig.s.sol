//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";

contract HelperConfig is Script{
    NetworkConfig public activeNetwork;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if(block.chainid == 11155111){
            activeNetwork = getSepoliaEthConfig();
        }else {
            
        }
        
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){

        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory){
        
        vm.startBroadcast();
        vm.stopBroadcast();

        return activeNetwork;
    }


}
