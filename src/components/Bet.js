import React, {useState} from 'react';
import { Table, Container, Button, Form } from 'react-bootstrap';
import punk from "../Assets/punks.png"
import bayc from "../Assets/bayc.png"
import doodles from "../Assets/doodles.jpg"
import  {ethers} from 'ethers';
import  Contract  from '../NFTFuturesBetting.json';


const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();
const address = '0xC63b12498601CB76A5a313907feFEe30cEd153FD';
const contract = new ethers.Contract(address, Contract.abi, signer);

const main = async () => {
    try{
        await contract.placeABid("test-collection", "floor_price", 1^18, {value:100000})
        console.log("Placed a bid")
    }catch (error){
        console.log("Error in contract integration", error);
    }
}

const Bet = (props) =>{

    const [form, setForm] = useState({"fee":'0.1',"collection": "test"})
    const [errors, setErrors] = useState({})

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
        console.log(form, "--");
        main()
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
                    </Form>
                </div>
            </div>
        </div>

    )
}

export default Bet