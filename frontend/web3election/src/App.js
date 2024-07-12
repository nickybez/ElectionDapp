import logo from "./logo.svg";
import "./App.css";
import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import ABI from "./ElectionManager.json";
import { Navbar } from "./components/Navbar.js";
function App() {
  return (
    <div className="HomePage">
      <Navbar></Navbar>
      <h1>My First Fullstack Decentralized App</h1>
      <p>
        This frontend has not been developed as the goal of this project was to
        demonstrate that I can develop contracts and connect them to a frotend
      </p>
    </div>
  );
}
export { App };
