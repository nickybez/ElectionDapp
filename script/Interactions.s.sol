// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "../lib/forge-std/src/Script.sol";
import {ElectionManager} from "../src/ElectionManager.sol";
import {DeployElectionManager} from "../script/DeployElectionManager.s.sol";
import {DevOpsTools} from "../lib/forge-std/foundry-devops/src/DevOpsTools.sol";

contract VoteInElection is Script {
    function vote(address MostRecentDeployment) public {
        ElectionManager(MostRecentDeployment).vote(ElectionManager(MostRecentDeployment).getCandidate(0));
    }

    function run() public {
        address mostrecentdeployment = DevOpsTools.get_most_recent_deployment("ElectionManager", block.chainid);

        vote(mostrecentdeployment);
    }
}
