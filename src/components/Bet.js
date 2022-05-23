import React from 'react';
import { Table, Container, Button, Form } from 'react-bootstrap';
import punk from "../Assets/punks.png"
import bayc from "../Assets/bayc.png"
import doodles from "../Assets/doodles.jpg"

const Bet = (props) =>{
    console.log(props)
    let image = ""
    let text = ""

    if(props.url === "Punks"){
        image = punk;
        text = "Crypto Punks";
    }else if(props.url === "BAYC"){
        image = bayc;
        text = "Bored Ape Yatch Club";
    }else{
        image = doodles;
        text = "Doodles";
    }

    return (
        <div>
            <div style={{display: "flex", axlignItems:"center", justifyContent: "center"}} className="mt-5 flex-row">
                <div className='mr-5'>
                    <img src={image} style={{height: "100px", width: "100px", borderRadius: "50%"}} />
                </div>
                <div className='ml-5' style={{marginLeft: "10px"}}>
                    <Table striped>
                            <thead>
                                <tr>
                                    <th>Floor Price</th>
                                    <th>Volume</th>
                                    <th>Unique Users</th>
                                    <th>Total Bets</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>50 ETH</td>
                                    <td>908.1k ETH</td>
                                    <td>5.2k</td>
                                    <td>3</td>
                                </tr>
                            </tbody>
                    </Table>
                </div>
            </div>
            <div style={{display: "flex", alignItems:"center", justifyContent: "center", marginTop: "10px"}}  >
                <div style={{width: '50%'}}>
                    <Form column='sm'>
                            <Form.Group className="mb-3">
                            <Form.Label htmlFor="textInput">Your Prediction</Form.Label>
                            <Form.Control type="text" id = "textInput" placeholder="Floor Price in ETH" />
                            </Form.Group>
                        <fieldset disabled>
                            <Form.Group className="mb-3">
                            <Form.Label htmlFor="disabledTextInput">Bid Amount</Form.Label>
                            <Form.Control id="disabledTextInput" placeholder="0.1 ETH" />
                            </Form.Group>
                        </fieldset>
                        <div style={{display: "flex", alignItems:"center", justifyContent: "center"}}>
                                <Button type="submit">Submit</Button>
                                
                        </div>
                    </Form>
                </div>
            </div>
        </div>

    )
}

export default Bet
