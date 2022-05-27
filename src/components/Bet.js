import React, {useState} from 'react';
import { Table, Container, Button, Form } from 'react-bootstrap';
import punk from "../Assets/punks.png"
import bayc from "../Assets/bayc.png"
import doodles from "../Assets/doodles.jpg"
import  {ethers} from 'ethers';
import  Contract  from '../../src/NFTFuturesBetting.json';


const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();
const address = '0x4aad781F93B03cA3681411F44b39A6BAF423F9F1';
const contract = new ethers.Contract(address, Contract.abi, signer);


const Bet = (props) =>{

    const [form, setForm] = useState({"fee":'0.1',"collection": "opensea-creature", "bettingOn": "floor_price"})
    const [errors, setErrors] = useState({})
    const [status, setStatus] = useState(false)

    const setField = (field, value) => {
        setForm(
            {
                ...form,
                [field]:value
            }
        )
        if(!!errors[field]){
            setErrors({
                ...errors,
                [field]:null
            })
        }
    }

    const main = async (form) => {
        try{
            console.log(form, "--");
            await contract.placeABid(form.collection, form.bettingOn, form.prediction, {value:1^17})
            console.log("Placed a bid")
            setStatus(true)

        }catch (error){
            console.log("Error in contract integration", error);
        }
    }

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

    const handleSubmit = e => {
        e.preventDefault()
        main(form)
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
                            <Form.Control type="text" id = "textInput" placeholder="Floor Price in ETH" onChange={e => setField('prediction', e.target.value)} value={form.value} isInvalid={!!errors.dob}/>
                            <Form.Control.Feedback type="invalid">
                                {errors.prediction}
                            </Form.Control.Feedback>
                            </Form.Group>
                        <fieldset disabled>
                            <Form.Group className="mb-3">
                            <Form.Label htmlFor="disabledTextInput">Bid Amount</Form.Label>
                            <Form.Control id="disabledTextInput" placeholder="0.1 ETH" />
                            </Form.Group>
                        </fieldset>
                        <div style={{display: "flex", alignItems:"center", justifyContent: "center"}}>
                                <Button type="submit" onClick={handleSubmit}>Submit</Button> 
                        </div>
                        {
                            status?<p>Bid placed Successfully !</p>:null
                        }
                        
                    </Form>
                </div>
            </div>
        </div>

    )
}

export default Bet