// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ElectionManager} from "../src/ElectionManager.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract DeployElectionManager is Script {
    ElectionManager election;
    string[] candidates = ["James", "John"];
    uint256 interval = 30;

    function run() public returns (ElectionManager) {
        vm.startBroadcast();
        election = new ElectionManager(candidates, interval);
        vm.stopBroadcast();
        return election;
    }
}
