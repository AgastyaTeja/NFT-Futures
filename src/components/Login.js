import React from 'react';

import { useState } from 'react'    
import { css } from '@emotion/css'
import { ethers } from 'ethers'
import Web3Modal from 'web3modal'
import WalletConnectProvider from '@walletconnect/web3-provider'
import 'easymde/dist/easymde.min.css'


// import '../styles/globals.css'
import Link from 'next/link'
import { AccountContext } from '../context.js'
// import { ownerAddress } from '../config'

// const Login = () => {
//     return(
//         <p> Login</p>
//     )
// }


const Login =({ Component, pageProps }) => {
    const [account, setAccount] = useState(null)
    /* create local state to save account information after signin */
    
    /* web3Modal configuration for enabling wallet access */
    async function getWeb3Modal() {
      const web3Modal = new Web3Modal({
        network: 'mainnet',
        cacheProvider: false,
        providerOptions: {
          walletconnect: {
            package: WalletConnectProvider,
            options: { 
              alchemyId: process.env.NEXT_PUBLIC_ALCHEMY_ID
            },
          },
        },
      })
      return web3Modal
    }
  
    /* the connect function uses web3 modal to connect to the user's wallet */
    async function connect() {
      try {
        const web3Modal = await getWeb3Modal()
        const connection = await web3Modal.connect()
        const provider = new ethers.providers.Web3Provider(connection)
        const accounts = await provider.listAccounts()
        setAccount(accounts[0])
        console.log(account);
        useraccount = account;
      } catch (err) {
        console.log('error:', err)
      }
    }

    return (
        <div className="container">
        <button onClick={connect}>Connect Wallet</button>  
     </div>
    )
 
}

const container = css`
  padding: 40px;
`
export default Login



   