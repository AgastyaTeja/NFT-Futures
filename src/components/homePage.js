import React from 'react';
import eth from "../Assets/ethimage.png"
import market from "../Assets/market.png"
import exchange from "../Assets/exchange.png"
import metamask from "../Assets/metamask.png"

const Home = () => {
    return(
        <div>
            <div style={{marginTop: "25px"}}>
                 <h3 style={{textAlign: "center"}}>NFT Futures</h3>
                 <p style={{textAlign: "center"}}> P2P way to spectulate on NFT prices!</p>
                {/* <div>
                <ul>Login via Metamask</ul>
                 <ul>Register for a bet</ul>
                 <ul>Speculate on the Floor Price</ul>
                 <ul>Get Rewarded once the bet ends</ul>
                </div> */}
            </div>
            <div style={{marginTop: "150px"}}>
                <div>
                    <h3 style={{textAlign: "center"}}>How it works?</h3>
                </div>
                <div className='d-flex justify-content-center' style={{marginTop: "25px"}}>

                    <div style={{width: "150px", height: "150px"}}>
                        {/* {Make a trade} */}
                        <img src={metamask} style={{height: "100px", width: "100px", borderRadius: "50%", border: "1px solid black", marginLeft: "auto", marginRight: "auto"}}/>
                        <p className='mt-3'>Metamask Login</p>
                    </div>

                    <div style={{width: "150px", height: "150px"}}>
                        {/* Deposit Funds */}
                        <img src={eth} style={{height: "100px", width: "100px", borderRadius: "50%", border: "1px solid black", marginLeft: "auto", marginRight: "auto"}}/>
                        <p className='mt-3'>Place a bet!</p>
                    </div>
                    <div style={{width: "150px", height: "150px"}}>
                        {/* Watch the Market */}
                        <img src={market} style={{height: "100px", width: "100px", borderRadius: "50%", border: "1px solid black",  marginLeft: "auto", marginRight: "auto"}}/>
                        <p className='mt-3'>Watch the Market</p>
                    </div>
                    <div style={{width: "150px", height: "150px"}}>
                        {/* {Make a trade} */}
                        <img src={exchange} style={{height: "100px", width: "100px", borderRadius: "50%", border: "1px solid black",  marginLeft: "auto", marginRight: "auto"}} className="ml-2"/>
                        <p className='mt-3'>Win the bet</p>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Home
