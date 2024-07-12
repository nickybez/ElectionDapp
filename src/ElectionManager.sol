// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ElectionManager {
    /*Type Declarations*/

    enum ElectionState {
        Voting,
        Counting
    }

    /*State Variables*/
    string[] s_candidate_names; //Array storing the names of each candidate, passed into the constructor
    mapping(string => uint256) private s_NameToNumberOfVotes; //Mapping the name of a candidate to the number of votes they have recieved
    ElectionState s_electionstate; //Stores the current state of the election, whether or not votes are being counted or people are voting
    uint256 s_latesttimestamp; //Stores the latest time stamp of when voting has begun
    uint256 private immutable i_interval; //Stores the amount of time which users have to vote
    string s_recentelectionwinnner;
    uint256 totalNumberOfVotes; //Stores the total number of votes which have been passed into the function

    /*Errors*/

    error VotingStillOn();
    error InvalidCandidate();
    error NotVoting();

    /*Modifiers*/

    /**
     * Decentralized Voting Contract Project
     * I built this project to showcase how the immutable characteristics of smart contracts on the Blockchain make voting and counting far more secure
     * Users can caste votes and a winmner out of the candidates which are passed in will be chosen
     */
    constructor(string[] memory candidate_names, uint256 votinginterval) {
        s_candidate_names = candidate_names; //Takes the names of the candidates as a parameter and stores them onto the chain
        s_electionstate = ElectionState.Voting; //Sets the state of the election to voting when the election has first started
        s_latesttimestamp = block.timestamp; //Sets the latest time stamp to the point at which this contract has been deployed
        i_interval = votinginterval;
        for (uint256 i = 0; i < candidate_names.length; ++i) {
            s_NameToNumberOfVotes[candidate_names[i]] = 0; //Sets the initial vote count for each candidate to equal 0;
        }
    }

    //This function allows users to vote
    function vote(string memory candidate_name) public {
        if (s_electionstate != ElectionState.Voting) {
            revert NotVoting();
        }
        bool candidatefound;
        for (uint256 i = 0; i < s_candidate_names.length; ++i) {
            if (keccak256(abi.encode(candidate_name)) == keccak256(abi.encode(s_candidate_names[i]))) {
                candidatefound = true;
            }
        }
        if (!candidatefound) {
            revert InvalidCandidate();
        }
        s_NameToNumberOfVotes[candidate_name] += 1; //Increments the votes which the candidate has recieved
        totalNumberOfVotes += 1; //Increments the total number of votes
    }

    //This function is using time-based automation to check the state of the election and see if is necessary to finish voting and start couting.
    function checkUpKeep() public view returns (bool upkeepNeeded) {
        uint256 time_passed = block.timestamp - s_latesttimestamp; //Calculates the amount of time which has passed since the last time at which voting had begun
        bool votingtimeended; //Boolean storing whether or not voting time has ended
        bool votescaste; //Boolean storing whether or not votes have been caste for a candidate yet
        if (time_passed >= i_interval) {
            //Checks if the voting time has surpassed the amount of time which users have to vote
            votingtimeended = true;
        }
        if (totalNumberOfVotes > 0) {
            //Checks if there have been any votes caste at all
            votescaste = true;
        }

        if (votescaste && votingtimeended) {
            /*If there have been votes caste and the time period of voting has been surpassed, 
            then the function returns upKeepNeeded as true meaning that the voting period 
            has ended and it is time to count the votes*/
            upkeepNeeded = true;
        }
    }

    //This function gets called when the voting period has ended and it is time to start counting

    function performUpKeep() public {
        if (!checkUpKeep()) {
            revert VotingStillOn(); //Function reverts if the checkUpKeep function returns false as this means that the voting period has not ended
        } else {
            uint256 max = 0;
            string memory winner;
            for (uint256 i = 0; i < s_candidate_names.length; ++i) {
                if (s_NameToNumberOfVotes[s_candidate_names[i]] > max) {
                    max = s_NameToNumberOfVotes[s_candidate_names[i]];
                    winner = s_candidate_names[i];
                }
            }
            s_recentelectionwinnner = winner;
            s_latesttimestamp = block.timestamp;
            totalNumberOfVotes = 0;
            s_electionstate = ElectionState.Counting;
        }
    }

    function getInterval() public view returns (uint256) {
        return i_interval;
    }

    function getCandidate(uint256 index) public view returns (string memory) {
        return s_candidate_names[index];
    }

    function getLatestTimeStamp() public view returns (uint256) {
        return s_latesttimestamp;
    }

    function getCurrentElectionState() public view returns (uint256) {
        return uint256(s_electionstate);
    }

    function getTotalNumberOfVotes() public view returns (uint256) {
        return totalNumberOfVotes;
    }

    function getCandidateVote(uint256 index) public view returns (uint256) {
        return s_NameToNumberOfVotes[s_candidate_names[index]];
    }

    function getRecentWinner() public view returns (string memory) {
        return s_recentelectionwinnner;
    }
}
