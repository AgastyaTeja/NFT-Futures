import React from 'react';
import { Table, Container, Button } from 'react-bootstrap';
import punk from "../Assets/punks.png"
import bayc from "../Assets/bayc.png"
import doodles from "../Assets/doodles.jpg"
import { useNavigate } from "react-router-dom";


const UpcomingBets = (props) => {


    return(
        <div>
            <div className='text-center mt-5'>
                <h4>Ongoing bets</h4>
            </div>
            <div>
                <Container>
                        <Table striped>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>NFT set</th>
                                <th>Floor Price</th>
                                <th>Volume</th>
                                <th>Unique Users</th>
                                <th>Total Bets</th>
                                <th>Bet</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td> <img src={punk} style={{height: "100px", width: "100px"}}/></td>
                                <td>CrytoPunks</td>
                                <td>50 eth</td>
                                <td>908.1k eth</td>
                                <td>5.2k</td>
                                <td>3</td>
                                <td><Button variant="secondary" className='align-middle' onClick={event =>  window.location.href='/betPunks'}>Place a bet</Button>{' '}</td>
                            </tr>
                            <tr>
                                <td><img src={bayc} style={{height: "100px", width: "100px"}}/></td>
                                <td>CrytoPunks</td>
                                <td>50 eth</td>
                                <td>908.1k eth</td>
                                <td>5.2k</td>
                                <td>3</td>
                                <td><Button variant="secondary" className='align-middle' onClick={event =>  window.location.href='/betBAYC'}>Place a bet</Button>{' '}</td>
                            </tr>
                            <tr>
                                <td><img src={doodles} style={{height: "100px", width: "100px"}}/></td>
                                <td>CrytoPunks</td>
                                <td>50 eth</td>
                                <td>908.1k eth</td>
                                <td>5.2k</td>
                                <td>3</td>
                                <td> <Button variant="secondary" className='align-middle'  onClick={event =>  window.location.href='/betDoodles'}>Place a bet</Button>{' '}</td>
                            </tr>
                        </tbody>
                    </Table>
                </Container>
            </div>
        </div>
    )
}

export default UpcomingBets