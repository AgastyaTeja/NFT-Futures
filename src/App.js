import React from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import NavbarComp from './components/Navbar';
import Login from './components/Login';
import History from './components/History';
import UpcomingBets from './components/UpcomingBets';
import Bet from './components/Bet';

import {BrowserRouter as Router, Routes, Route } from "react-router-dom";

function App() {
  return (
    <div className="App">
        <Router>
          <NavbarComp />
          <Routes>
              <Route path="/login" element={<Login />} />
              <Route path="/history" element={<History />} />
              <Route path="/upcomingbets" element={<UpcomingBets url={"upcomingBets"}/>} />
              <Route path="/betBAYC" element={<Bet url={"BAYC"}/>} />
              <Route path="/betPunks" element={<Bet url={"Punks"}/>} />
              <Route path="/betDoodles" element={<Bet url={"Doodles"}/>} />
          </Routes>
        </Router>
    </div>
  );
}
export default App;

// import { ethers } from 'ethers';
// import Contract from "./NFTFuturesBetting.json"

// const provider = new ethers.providers.Web3Provider(window.ethereum);
// const signer = provider.getSigner();
// console.log("Signers",provider.getSigner());
// const address = '0xC63b12498601CB76A5a313907feFEe30cEd153FD';
// const contract = new ethers.Contract(address, Contract.abi, signer);
// const main = async () => {
//     try{
//         await contract.placeABid("opensea-creature", "floor_price", 1^18, {value:1^17})
//         console.log("Placed a bid")
//         // await contract.connect("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266").placeABid("opensea-creature", "floor_price", 1^18, {value:1^17})
//         // console.log("Placed a bid")

//     }catch (error){
//         console.log("Error in contract integration", error);
//     }
// }
// main()
