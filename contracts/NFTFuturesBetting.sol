//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTFuturesBetting {

    using Counters for Counters.Counter;

    Counters.Counter private betCounter;
    address private owner;
    uint private minEthBalRequired = 10000000000000000; // 0.1 ETH
    uint public lastRunBetsTimestamp; // getRid of this as bets start when userBids array is of size 2

    // enum of bet status
    enum BetStatus {
       AVAILABLE,
       STARTED,
       COMPLETED,
       FAILED  //Will there be a failed bid?
    }

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
    mapping(uint => Bet) public bets;

    mapping(address => mapping(BetStatus => Bet[])) public userBets;

    mapping(string => mapping(BetStatus => Bet[])) public nftBets;

    constructor() payable {
        owner = address(this);
    }

    function deposit() public payable {}

     // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    // Eventually get these from dummy API/Chainlink ?
    function createBets() private  {
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
    function getAllBets() public view returns (Bet[] memory) {

        Bet[] storage allBets;

        for(uint i=0; i < betCounter.current(); ++i){
           allBets.push(bets[i]);
        }

        return allBets;
    }

    // _history of bets of the user
    function getAllBetsOfTheUser() public view returns (Bet[] memory) {
        //address sender = msg.sender;
        Bet[] storage allBetsOfUser;

        mapping(BetStatus => Bet[]) storage _userBetsMapping = userBets[address(msg.sender)];

        allBetsOfUser.push(_userBetsMapping[BetStatus.AVAILABLE]);
        allBetsOfUser.push(_userBetsMapping[BetStatus.COMPLETED]);
        allBetsOfUser.push(_userBetsMapping[BetStatus.STARTED]);

        return allBetsOfUser;
    }


    function preconditioncheck(address user, uint value, string memory nftCollection) public view {
        // Check if bet already has two users in it, error out, ask to wait for anohter 60m
        // Check if user already had put bet on this nftCollection
        // nftCollection.state = current and nftCollection.userCount != 0
        // if nftcollection.state = current && users.count != 0 && user1.address != user && user2.address != user
    }

    /** Place a bet functionality */
    function placeABet(string memory nftCollection, uint betValue, uint prediction) public payable {
        /* Check if this user is valid:
            1. Dupliation: User has not placed the bet yet on nftCollection in the current on-going round
            2. User bet value >= minEthBalRequired
            3. User has enough funds >= minEthBalRequired
           Add user to the bet as one of the user
           Error our if there are already two users on this bet in this current round
        */
        require(betValue >= minEthBalRequired,"Bet val must be at least 0.01 ETH");
        require(msg.value >= minEthBalRequired, "Not sufficient ETH in your wallet :(");
        this.preconditioncheck(msg.sender, betValue, nftCollection);

        // assume nftCollection and betID and go ahead and add user to it
        // if() { //userBids size is not 2
        //     // add user to userBids array for this betID
        // }

        // tansfer money to contract address
        // "": msg.data. is empty => receiving address should have a receive() defined to get ETH,
        //otherwise it does a Falllback()
        (bool success,) = address(this).call{value: betValue}("");
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
