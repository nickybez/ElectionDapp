import React from "react";
import { Link } from "react-router-dom";

function Navbar() {
  return (
    <nav>
      <label>
        <Link to="/">Home </Link>
        <Link to="/votingpage"> Voting Page</Link>
        <Link to="/ConnectWallet"> Connect Wallet</Link>
      </label>
    </nav>
  );
}

export { Navbar };
