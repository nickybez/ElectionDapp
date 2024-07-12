import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import { Navbar } from "../components/Navbar.js";
import { Button } from "@material-ui/core";

function WalletCard() {
  const provider = new ethers.providers.Web3Provider(window.ethereum);

  const [errorMessage, setErrorMessage] = useState(null);
  const [defaultAccount, setDefaultAccount] = useState(null);
  const [userBalance, setUserBalance] = useState(null);
  const connectwalletHandler = () => {
    if (window.Ethereum) {
      provider.send("eth_requestAccounts", []).then(async () => {
        await accountChangedHandler(provider.getSigner());
      });
    } else {
      setErrorMessage("Please Install Metamask!!!");
    }
  };

  const getuserBalance = async (address) => {
    const balance = await provider.getBalance(address, "latest"); //Gets the most recent balance of that account to set in the state
  };

  const accountChangedHandler = async (newAccount) => {
    //Takes a account as a parameter
    const address = await newAccount.getAddress(); //Gets the address of that account wallet
    setDefaultAccount(address); //Sets the default account in the state as that address
    const balance = await newAccount.getBalance(); //Gets the current balance stored in that address
    setUserBalance(ethers.utils.formatEther(balance)); //Converts the balance from wei to Ether
    await getuserBalance(address); //Waits until the user's balance is updated before the next trasaction
  };
  return (
    <div className="WalletCard">
      <Navbar></Navbar>
      <Button
        style={{ background: defaultAccount ? "#A5CC82" : "white" }}
        onClick={connectwalletHandler}
      >
        {defaultAccount ? "Connected!!" : "Connect"}
      </Button>

      <div className="displayAccount">
        <h4 className="walletAddress">Address:{defaultAccount}</h4>
        <div className="balanceDisplay">
          <h3>Wallet Amount: {userBalance}</h3>
        </div>
      </div>
    </div>
  );
}

export { WalletCard };
