// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {ElectionManager} from "../../src/ElectionManager.sol";
import {DeployElectionManager} from "../../script/DeployElectionManager.s.sol";
import {VoteInElection} from "../../script/Interactions.s.sol";

contract ElectionManagerIntegrationTest is Test {
    DeployElectionManager deployer;
    ElectionManager election;

    function setUp() public {
        deployer = new DeployElectionManager();
        election = deployer.run();
    }

    function testUserCanVote() public {
        VoteInElection voteinelection = new VoteInElection();
        voteinelection.vote(address(election));
        assertEq(election.getTotalNumberOfVotes(), 1);
    }
}
