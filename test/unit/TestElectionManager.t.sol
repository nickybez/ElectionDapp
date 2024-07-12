// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console2} from "../../lib/forge-std/src/Test.sol";
import {ElectionManager} from "../../src/ElectionManager.sol";
import {DeployElectionManager} from "../../script/DeployElectionManager.s.sol";

contract TestElectionManager is Test {
    ElectionManager election;
    DeployElectionManager deployer;
    address voter = makeAddr("vote");
    address othervoter = makeAddr("othervote");

    function setUp() public {
        deployer = new DeployElectionManager();
        election = deployer.run();
    }

    /*Tests for vote method*/

    function testVoteRevertsWhenTheElectionStateIsCounting() public {
        vm.expectRevert(ElectionManager.NotVoting.selector);

        vm.startPrank(voter);
        election.vote(election.getCandidate(0));
        vm.warp(election.getInterval() + election.getLatestTimeStamp());
        vm.roll(1);
        election.performUpKeep();
        console2.log(election.getCurrentElectionState());

        election.vote(election.getCandidate(1));
        vm.stopPrank();
    }

    function testVoteRevertswhenInvalidCandidateIsPassed() public {
        vm.startPrank(voter);
        vm.expectRevert(ElectionManager.InvalidCandidate.selector);
        election.vote("Ahmed");

        vm.stopPrank();
    }

    modifier Voted() {
        vm.startPrank(voter);
        election.vote(election.getCandidate(0));
        vm.stopPrank();
        _;
    }

    function testVoteUpdatesTheTotalVotesAndVotesForEachCandidate() public Voted {
        assertEq(election.getTotalNumberOfVotes(), 1);
        assertEq(election.getCandidateVote(0), 1);
    }

    /* CheckUpKeep Tests */
    function testCheckUpKeepReturnsFalseIfNotEnoughTimePassed() public Voted {
        bool upkeepneeded = election.checkUpKeep();

        assert(!upkeepneeded);
    }

    function testCheckUpKeepReturnsFalseIfNoVotes() public {
        vm.warp(election.getInterval() + election.getLatestTimeStamp());
        bool upKeepNeeded = election.checkUpKeep();
        assert(!upKeepNeeded);
    }

    /* PerformUpKeep Tests */

    function testPerformUpKeepRevertIfPerformUpKeepReturnsFalse() public {
        vm.expectRevert(ElectionManager.VotingStillOn.selector);
        election.performUpKeep();
    }

    function testPerformUpKeepUpdatesElectionState() public Voted {
        vm.warp(election.getLatestTimeStamp() + election.getInterval());
        election.performUpKeep();
        uint256 final_state = (election.getCurrentElectionState());
        assert(final_state == 1);
    }

    function testPerformUpKeepUpdatesLatestTimeStamp() public Voted {
        uint256 initial_timestamp = election.getLatestTimeStamp();
        vm.warp(election.getLatestTimeStamp() + election.getInterval());
        election.performUpKeep();
        uint256 final_timestamp = election.getLatestTimeStamp();
        assertEq(final_timestamp, initial_timestamp + election.getInterval());
    }

    function testPerformUpKeepResetsTotalVotes() public Voted {
        vm.warp(election.getLatestTimeStamp() + election.getInterval());
        election.performUpKeep();
        assertEq(election.getTotalNumberOfVotes(), 0);
    }
}
