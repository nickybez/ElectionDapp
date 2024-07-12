import React from "react";
import { Navbar } from "../components/Navbar.js";
import { ethers } from "ethers";

import abi from "../ElectionManager.json";

const contractaddress = "0xa3eF4b59C13ad3D6511e13Fb483D4b03c482Ece1";
function getABI() {
  return abi;
}
function Election() {
  const provider = new ethers.providers.getDefaultProvider(
    "https://sepolia.infura.io/v3/f4ef4a8d16724690bde3179440a45e36"
  ); //Connects to the Sepolia chain
  const recieveABI = async () => {
    await getABI();
  };

  let abi = [{ ...abi }];
  const ElectionContract = new ethers.Contract(contractaddress, abi, provider); //Create an instance of the election contract

  async function vote(candidate) {
    try {
      const vote = await ElectionContract.vote(candidate); //Callls the vote functiion in the contract
      setTimeout(getResult(), (ElectionContract.getInterval() * 10) ^ 3); // Gets the result after the interval has passed
    } catch (error) {
      return (
        <p>
          Sorry, voting is currently not working, please try again later. Check
          if the candidate you have entered is valid and if voting is currently
          on
        </p>
      );
    }
  }
  async function getResult() {
    try {
      const upkeep = await ElectionContract.performUpkeep(); //Internally calls the result after the voting interval has passed
      const winner = await ElectionContract.getRecentWinner();
    } catch (error) {
      return <p>Error fetching results, please try again later</p>;
    }
  }
  /*Candidates are defined when the contract is deployed*/

  return (
    <div>
      <Navbar></Navbar>
      <h1>Voting</h1>;<h2>Candidates</h2>
      <button onClick={vote(ElectionContract.getCandidate(0))}>
        Vote for John
      </button>{" "}
      <button onClick={vote(ElectionContract.getCandidate(1))}>
        Vote for James
      </button>
    </div>
  );
}

export { Election };
