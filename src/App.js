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
