import  {ethers} from 'ethers';
import  Contract  from '../NFTFuturesBetting.json';


const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();
const address = '0x9213eD6E298037B077A17A0d50F53366B3c9E7Df';
const contract = new ethers.Contract(address, Contract.abi, signer);


const main = async (form) => {
    try{
        form.prediction = parseFloat(form.prediction)
        await contract.placeABid(form.collection, form.bettingOn, form.prediction, {value:"100000000000000000"})
        console.log("Placed a bid")
        setStatus(true)

    }catch (error){
        console.log("Error in contract integration", error);
    }
}

const getHistory = async () => {
    try{
        return await contract.getAllBets()
        
        // console.log(result, "-->")
    }catch (error){
        console.log("Error in contract integration", error);
    }
}
export  default main;
export {getHistory}
