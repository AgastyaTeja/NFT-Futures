import React, {useEffect, useState} from 'react';

import { Link,useNavigate } from 'react-router-dom';
import { Navbar, NavDropdown, Nav, Container } from 'react-bootstrap';
import { css } from '@emotion/css'
import { ethers } from 'ethers'
import 'easymde/dist/easymde.min.css'
import Web3Modal from 'web3modal'
import WalletConnectProvider from '@walletconnect/web3-provider'
// import { AccountContext } from '../context.js'
require("dotenv").config();
const INFURA_ID = process.env.INFURA_ID;
console.log("Infura id",INFURA_ID)
const NavbarComp = () =>{
    let navigate = useNavigate(); 
    const storedAccount = localStorage.getItem('account');
    
    const [account, setAccount] = useState(
      (storedAccount) ? storedAccount : null
    );
    useEffect(() => {
      window.localStorage.setItem('account', String(account));
    }, [account]);
    
    async function getWeb3Modal() {
      const web3Modal = new Web3Modal({
        network: 'mainnet',
        cacheProvider: false,
        providerOptions: {
          walletconnect: {
            package: WalletConnectProvider,
            options: { 
              // infuraId: 
              infuraId: INFURA_ID
            },
          },
        },
      })
      return web3Modal
    }
    async function connect() {
      try {
        const web3Modal = await getWeb3Modal()
        const connection = await web3Modal.connect()
        const provider = new ethers.providers.Web3Provider(connection)
        const accounts = await provider.listAccounts()
        setAccount(accounts[0])               
      } catch (err) {
        console.log('error:', err)
      }
    }
    async function disconnect(){      
        try{
          const web3Modal = await getWeb3Modal()
          await web3Modal.clearCachedProvider();
          setAccount(null);    
          let path = `/`; 
          navigate(path);                
        }
        catch (err) {
          console.log('error:', err)
        }    
        return           
    }


    return(
        <Navbar collapseOnSelect expand="lg" bg="dark" variant="dark">
        <Container>
        <Navbar.Brand href="/">NFT-Futures</Navbar.Brand>
        <Navbar.Toggle aria-controls="responsive-navbar-nav" />
        <Navbar.Collapse id="responsive-navbar-nav">

          <Nav className="me-auto d-flex align-items-center mt-3">
            {account ? <Nav.Link href="/upcomingbets">{<p>Upcoming Bets </p>}</Nav.Link> : <Nav.Link href="/upcomingbets" disabled>{<p>Upcoming Bets </p>}</Nav.Link>}
            {account ? <Nav.Link href="/history">{<p>History</p>}</Nav.Link> : <Nav.Link href="/history" disabled>{<p>History</p>}</Nav.Link>}
          </Nav>  
          {
            !account && (          
              <Nav>
              {/* <Nav.Link href="/login">Login</Nav.Link> */}
              <button onClick={connect}>Connect Wallet</button>  
              </Nav>)
          }                 
          {
            account && <p className={accountInfo}>{account}</p> && (          
              <Nav>
              {/* <Nav.Link href="/login">Login</Nav.Link> */}
              <button onClick={disconnect}>Disconnect Wallet</button>  
              </Nav>)
          }   
               
        </Navbar.Collapse>
        </Container>
      </Navbar>
    )
}

export default NavbarComp;



{/* <Navbar bg="light" expand="lg">
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
</Navbar> */}

const accountInfo = css`
  width: 100%;
  display: flex;
  flex: 1;
  /*justify-content: flex-;*/
  font-size: 14px;
  color: white;
`
