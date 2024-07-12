import React from "react";
import "./index.css";
import { App } from "./App.js";
import reportWebVitals from "./reportWebVitals";
import * as ReactDOM from "react-dom/client";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { WalletCard } from "./pages/WalletCard.js";
import { Election } from "./pages/Election.js";

const router = createBrowserRouter([
  { path: "/", element: <App></App> },
  {
    path: "ConnectWallet",
    element: <WalletCard></WalletCard>,
  },
  {
    path: "votingpage",
    element: <Election></Election>,
  },
]);

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <React.StrictMode>
    <RouterProvider router={router} />;
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
