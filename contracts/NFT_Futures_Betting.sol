//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;
 
contract NFTFuturesBetting {
    uint betID;
    address private owner;
    uint private min_eth_bal_required = 10000000000000000; // 0.1 ETH
    uint lastRunBetsTimestamp; // getRid of this as bets start when userBids array is of size 2

    // enum of bet status 
    enum BetStatus {
       AVAILABLE,
       STARTED,
       COMPLETED,
       FAILED // Will there be a failed bid?
    }

    //mapping(user address => betIDs); -> update during placeABet etc 
    
    //mapping NFTCollection => betIDs 

    // Define structure Bet
    struct Bet {
        // refer: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol 
        uint betID; 
        /** 
            nftCollection uniquely identifies the nft collection and its parameter. 
            There are two options to generate this unique identifies for each collection + parameter combo:
            1. concatenate nft_collection_name + parameter name 
            2. generate a guid and use it as bidID also instead of another guid   
        */
        string nftCollection; // e.g., "Dooplicator_FloorPrice", "Dooplicator_VolumeTraded" etc
        Bid[] userBids; // For demo size is 2 [Bid1, Bid2]
        BetStatus status; 
        uint startTime; 
        uint endTime;
    }

    struct Bid {
        address user; 
        string nftCollection;
        uint value; //0.1 ETH
        uint timeBidIsPlaced; 
        uint prediction; 
    }

    // mapping betID => corresponding bet 
    mapping(uint => Bet) private bets;
    // For efficiency reasons Solidity/EVM does not store iterative keys, so maintain another array for keys to 
    // traverse through the mapping bets 
    uint[] private keys;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner");
        _;
    }

    constructor() payable {
        owner = payable(msg.sender);
        createBets(); 
        //lastRunBetsTimestamp = block.timestamp;
        betID = 0;
    }

    //using Counters for Counters.Counter;
    //Counters.Counter private _betId;
    // Import Counter from openzepplin 

    function deposit() public payable {}
    receive() external payable {}

    // Eventually get these from dummy API/Chainlink ?
    function createBets() private onlyOwner {
        // bets[0].betID = betID.increment(); keys.push(betID); betID++;
        // bets[0].nftCollection="Dooplicator_Items";
        // bets[1].betID = betID.increment(); keys.push(betID); betID++;
        // bets[1].nftCollection="Dooplicator_Owners";
        // bets[2].betID = betID.increment(); keys.push(betID); betID++;
        // bets[2].nftCollection="Dooplicator_FloorPrice";
        // bets[3].betID = betID.increment(); keys.push(betID); betID++;
        // bets[3].nftCollection="Dooplicator_VolumeTraded";
    }

    /*
        UI calls this function to update itself with all the bets that are available. 
        This function will return two associative arrays, 
        1st array contains list of uints which represent betIDs
        2nd array contains list of Bet which represent bets. 
    */
    function getAllBets() public view returns (uint[] memory betsKeys, Bet[] memory betsValues) {
        uint len = keys.length; 
        
        uint[] memory _betsKeys = new uint[](10);
        Bet[] memory _betsValues = new Bet[](10);

        for(uint i=0; i<len; ++i){
            betsKeys[i] = keys[i];
            betsValues[i] = bets[keys[i]];
        }

        return(_betsKeys, _betsValues);
    }

    // _history of bets of the user
    function getAllBetsOfTheUser() public view returns (Bet[] memory) {
        //address sender = msg.sender;
        Bet[] memory allBetsOfUser;

        // Iterate on bets and add those with either user1 == sender or user2 == sender
        for(uint i=0; i<keys.length; ++i){
            // if(bets[keys[i]].user1 == msg.sender || bets[keys[i]].user2 == msg.sender){
            //     allBetsOfUser[allBetsOfUser.length] = bets[keys[i]]; 
            // }
            // Iterate over userBids array to determine if user is part of this bet and 
            // add to allBetsOfUser
        }

        return allBetsOfUser;
    }


    function preconditioncheck(address user, uint value, string memory nftCollection) public view {
        // Check if bet already has two users in it, error out, ask to wait for anohter 60m
        // Check if user already had put bet on this nftCollection 
        // nftCollection.state = current and nftCollection.userCount != 0
        // if nftcollection.state = current && users.count != 0 && user1.address != user && user2.address != user
    }

    /** Place a bet functionality */ 
    function placeABet(string memory nftCollection, uint value) public payable {
        /* Check if this user is valid: 
            1. Dupliation: User has not placed the bet yet on nftCollection in the current on-going round 
            2. User bet value >= min_eth_bal_required
            3. User has enough funds >= min_eth_bal_required 
           Add user to the bet as one of the user
           Error our if there are already two users on this bet in this current round 
        */
        require(value >= min_eth_bal_required, "Bet val must be at least 0.01 ETH");
        require(msg.value >= min_eth_bal_required, "Not sufficient ETH in your wallet :(");
        this.preconditioncheck(msg.sender, value, nftCollection);

        // assume nftCollection and betID and go ahead and add user to it 
        // if() { //userBids size is not 2
        //     // add user to userBids array for this betID 
        // }

        // tansfer money to contract address 
        // "": msg.data. is empty => receiving address should have a receive() defined to get ETH, 
        //otherwise it does a Falllback() 
        (bool success,) = address(this).call{value: value}("");
        require(success, "Failed to send Ether!");

        // is userBids size is 2, then update startTime, correspondigly update endTime of this bet

        // run bet logic
        if (success) {
            runBets();
        } 
    }

    function runBets() private {
        if (block.timestamp == lastRunBetsTimestamp + 60 minutes) {
            // reset lastRunBetsTimestamp 
            lastRunBetsTimestamp = block.timestamp; 

            // run bet, getWinner, transferMoney etc etc 

        }
    }


    // return list of betIDs 
    //function getAllBetsOfTheNFT(string memory nftCollection) internal view returns (mapping(uint => Bet) storage) {
    function getAllBetsOfTheNFT() internal view returns (mapping(uint => Bet) storage) {
        mapping(uint => Bet) storage allNFTBets = bets; 
        // Iterate on bets and add those with nftCollection = nftCollection parameter
        return allNFTBets;
    }

}
