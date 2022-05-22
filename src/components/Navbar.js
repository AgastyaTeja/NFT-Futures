import React, {useState} from 'react';

import { Link } from 'react-router-dom';
import { Navbar, NavDropdown, Nav, Container } from 'react-bootstrap';

const NavbarComp = () =>{
    return(
        <Navbar collapseOnSelect expand="lg" bg="dark" variant="dark">
        <Container>
        <Navbar.Brand href="#home">NFT-Futures</Navbar.Brand>
        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
        <Navbar.Collapse id="responsive-navbar-nav">
          <Nav className="me-auto">
            <Nav.Link href="/upcomingbets">Upcoming Bets</Nav.Link>
            <Nav.Link href="/history">History</Nav.Link>
          </Nav>
          <Nav>
            <Nav.Link href="#deets">Login</Nav.Link>
          </Nav>
        </Navbar.Collapse>
        </Container>
      </Navbar>
    )
}

export default NavbarComp;



<Navbar bg="light" expand="lg">
<Container>
    <Navbar.Brand href="#home">NFT-Futures</Navbar.Brand>
    <Navbar.Toggle aria-controls="basic-navbar-nav" />
    <Navbar.Collapse id="basic-navbar-nav">
    <Nav className="me-auto">
        <div className="d-flex">
            <Nav.Link href="/upcomingbets">Upcoming Bets</Nav.Link>
            <Nav.Link href="/history">History</Nav.Link>
            <Nav.Link href="#" className="justify-content-end">Login</Nav.Link>
        </div>
        </Nav>
        
    </Navbar.Collapse>
</Container>
</Navbar>