//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

/*
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

contract NFTFuturesBetting is ChainlinkClient {

    using Chainlink for Chainlink.Request;
    using Counters for Counters.Counter;
    string[] public result;
    event RequestVolume(bytes32 indexed requestId, uint256 volume);

    bytes32 private jobId;
    uint256 private fee;
    Counters.Counter private betCounter;
    uint private minEthBalRequired = 10000000000000000; // 0.1 ETH
    address payable private owner;

    // enum of bet status
    enum BetStatus {
       AVAILABLE,
       RUNNING,
       COMPLETED,
       FAILED
    }

    /*
    map betId => corresponding bet
    For efficiency reasons Solidity/EVM does not store iterative keys, so maintain another array for keys to
    traverse through the mapping bets
    */
    mapping(uint => Bet) private bets;
    uint[] private betIds;

    // map nftId => corresponding all betIds where nftId = nftCollection_property
    // mapping(string => uint[]) private nftToBets;
    mapping(string => uint[]) public nftToBets;

    // map reqId(chainlink) => betId
    mapping(bytes32 => uint) private chainlinkReqToBetId;

    struct Bet {
        // refer: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
        uint betId;
        string nftCollection; // e.g., "Dooplicator"
        string property; // e..g, "floor_price, "volume_traded"
        Bid userBid1; // Note: When I made it array of userBids, there was compile error that memory cannot be stored into storage
        Bid userBid2;
        BetStatus status;
        uint startTime;
        uint endTime;
        uint closingPropertyValue;
        address winner;
    }

    struct Bid {
        address user;
        uint prediction;
    }

    /*
     * @notice Initialize the link token and target oracle
     *
     * Kovan Testnet details:
     * Link Token: 0xa36085F69e2889c224210F603D836748e7dC0088 0xa36085F69e2889c224210F603D836748e7dC0088
     * Oracle: 0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656 (Chainlink DevRel)
     * jobId: ca98366cc7314957b8c012c72f05aeeb
     *
     */
    constructor() payable {
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
        setChainlinkOracle(0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656);
        jobId = 'ca98366cc7314957b8c012c72f05aeeb';
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
        owner = payable(msg.sender);
    }

    function deposit() public payable {}
    receive() external payable {}

    /*
        UI calls this function to update itself with all the bets that are available.
        This function will return two associative arrays,
        1st array contains list of uints which represent betIDs
        2nd array contains list of Bet which represent bets.
    */
    function getAllBets() public view returns (Bet[] memory betsValues) {
        uint len = betIds.length;

        Bet[] memory _betsValues = new Bet[](len);

        for(uint i=0; i<len; ++i){
            _betsValues[i] = bets[betIds[i]];
        }

        return _betsValues;
    }


    // Note: Introduced for testing
    function printABet(uint index) public view {
        Bet memory bet = bets[betIds[index]];

        // uint betId;
        // string nftCollection; // e.g., "Dooplicator"
        // string property; // e..g, "floor_price, "volume_traded"
        // Bid userBid1; // When I made it array of userBids, there was compile error that memory cannot be stored into storage
        // Bid userBid2;
        // BetStatus status;
        // uint startTime;
        // uint endTime;
        // uint closingPropertyValue;
        // address winner;

        console.log(bet.betId, bet.winner, bet.userBid1.user);
        console.log(bet.userBid2.user, bet.nftCollection, bet.property);

    }

    // All bets of the user
    function getAllBetsOfTheUser() public view returns (Bet[] memory) {
        uint n = betIds.length;
        Bet[] memory allBetsOfUser = new Bet[](n);
        uint index;
        // Iterate on bets and add those with either user1 == sender or user2 == sender

        for(uint i=0; i< n; ++i){
            Bet memory bet = bets[betIds[i]];
            if(bet.userBid1.user == msg.sender || bet.userBid2.user == msg.sender){
                allBetsOfUser[index++] = bet;
            }
        }

        return allBetsOfUser;
    }

    function _getNFTId(string memory nftCollection, string memory property) private pure returns(string memory) {
        return string(abi.encodePacked(nftCollection, "_", property));
    }

    function _createNewBet(string memory nftCollection, string memory property, Bid memory bid) private returns(Bet memory) {
        Bet memory newBet = Bet({
            betId: betIds.length,
            nftCollection: nftCollection,
            property: property,
            status: BetStatus.AVAILABLE,
            startTime: block.timestamp,
            endTime: 0,
            userBid1: bid,
            userBid2: Bid(address(0), 0),
            winner: address(0),
            closingPropertyValue: 0
        });

        bets[newBet.betId] = newBet;
        betIds.push(newBet.betId);
        nftToBets[_getNFTId(nftCollection, property)].push(newBet.betId);
        return newBet;
    }

    function _getBet(string memory nftCollection, string memory property, Bid memory bid) private returns(Bet memory) {
        // require(msg.value >= minEthBalRequired, "Not sufficient ETH in your wallet :(");

        // Check if bet already has two users in it, error out, ask to wait for anohter 60m
        uint[] memory nftBets = nftToBets[_getNFTId(nftCollection, property)];
        if (nftBets.length == 0) {
            return _createNewBet(nftCollection, property, bid);
        }

        Bet memory latestBet = bets[nftBets[nftBets.length - 1]];
        if (latestBet.status == BetStatus.COMPLETED) {
            return _createNewBet(nftCollection, property, bid);
        }

        // Check if user already had put bet on this nftCollection
        if (latestBet.status == BetStatus.AVAILABLE) {
            require (latestBet.userBid1.user != msg.sender, "User already placed bid");
            latestBet.userBid2 = bid;
            bets[nftBets[nftBets.length - 1]] = latestBet;
        }

        require(latestBet.status != BetStatus.RUNNING, "Maximum users exceeded error");
        return latestBet;
    }

    function placeABid(string calldata nftCollection, string calldata property, uint prediction) public payable {
        
        Bid memory bid = Bid({
            user: msg.sender,
            prediction: prediction
        });
        Bet memory bet = _getBet(nftCollection, property, bid);
        
        console.log(bet.userBid1.user, bet.userBid2.user, bet.nftCollection, bet.property);

        // tansfer money to contract address
        // If msg.data is empty => receiving address should have a receive() defined to get ETH,
        //otherwise it does a Falllback()
        //address payable con =  payable (address(this));
        (bool success,) = address(this).call{value: msg.value}("");
        require(success, "Failed to send Ether!");

        // If userBid2 exists, then bet is full, go run runBet function
        if (bet.userBid2.user != address(0)) {
            bet.status = BetStatus.RUNNING;
            console.log("Running the bet");
            console.log(bet.userBid1.user, bet.userBid2.user, bet.nftCollection, bet.property);
            _runBet(bet);
            // _runBetOnlyForTesting(); //Note: Introduced for testing
        }        
        console.log("Place a bid start for user:", msg.sender, ",", string(abi.encodePacked(nftCollection, property, prediction)));
    }

    function _runBet(Bet memory bet) public payable {
        console.log("In run bet");
        bytes32 reqId = _requestCollectionProperty(bet.nftCollection, bet.property);
        // result.push( "after chainlink call";
        console.log("Request ID, betId", bet.betId, string(abi.encodePacked(reqId)));
        chainlinkReqToBetId[reqId] = bet.betId;       
    }

    // Note: Introduced for testing
    function _runBetOnlyForTesting() public payable{
        getWinner();
    }

    // Note: Introduced for testing
    function getWinner() public payable {
        uint propertyValue = 5400;
        uint betId = 0;
        Bet storage bet = bets[betId];
        bet.closingPropertyValue = propertyValue;
        uint prediction1 = bet.userBid1.prediction;
        uint prediction2 = bet.userBid2.prediction;

        if (abs((int(prediction1) - int(propertyValue))) <= abs((int(prediction2) - int(propertyValue)))) {
        // if (abs(int(prediction1 - propertyValue)) <= abs(int(prediction2 - propertyValue))) {
            bet.winner = bet.userBid1.user;
        } else {
            bet.winner = bet.userBid2.user;
        }
        
        console.log(bet.winner, bet.closingPropertyValue, prediction1, prediction2);
        (bool success,) = payable(address(bet.winner)).call{value: 2*minEthBalRequired}("");
        console.log("Sent money to winner", bet.winner);
        if (success) {
            bet.status = BetStatus.COMPLETED;
            
        } else {
           bet.status = BetStatus.FAILED;
        }
        console.log("Bet status",string(abi.encodePacked(bet.status)));
    }

      /*
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function _requestCollectionProperty(string memory nftCollection, string memory property) internal returns (bytes32 requestId) {
        console.log("In request collection property");
        result.push( "in chainlink call");
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        req.add("get", string(abi.encodePacked("https://testnets-api.opensea.io/api/v1/collection/", nftCollection, "/stats/?format=json")));
        // req.add("path", string(abi.encodePacked("stats", property)));
        req.add("path","stats,floor_price");
        int256 timesAmount = 10**18;
        req.addInt("times", timesAmount);
        result.push( "Amount");
        console.log("converted the amount");
        // console.log("Timesamout",string(timesAmount));

        // Sends the request
        
        return sendChainlinkRequest(req, fee);
    }

    function abs(int x) private pure returns (int) {
        return x >= 0 ? x : -x;
    }

    /*
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 propertyValue) public recordChainlinkFulfillment(_requestId) {
        // console.log("In Fulfill");
        uint betId = chainlinkReqToBetId[_requestId];
        Bet storage bet = bets[betId];
        bet.closingPropertyValue = propertyValue;
        uint prediction1 = bet.userBid1.prediction;
        uint prediction2 = bet.userBid2.prediction;
        console.log("BetID, Predictions",string(abi.encodePacked(betId,prediction1, prediction2)) );
        result.push( "deciding winner");
        if (abs((int(prediction1) - int(propertyValue))) <= abs((int(prediction2) - int(propertyValue)))) {
        // if (abs(int(prediction1 - propertyValue)) <= abs(int(prediction2 - propertyValue))) {
            bet.winner = bet.userBid1.user;
            result.push("user1 is the winner");
            console.log("User 1 is the winner");
        } else {
            bet.winner = bet.userBid2.user;
            result.push("user2 is the winner");
            console.log("User 2 is the winner");
        }
        result.push( "sending money to winner");
        (bool success,) = payable(address(bet.winner)).call{value: 2*minEthBalRequired}("");
        console.log("Sent money to winner", bet.winner);
        result.push( "sent money to winner");
        if (success) {
            bet.status = BetStatus.COMPLETED;
            
        } else {
           bet.status = BetStatus.FAILED;
        }
        console.log("Bet status",string(abi.encodePacked(bet.status)));        
        result.push( "fulfill end");
    }

    /*
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public  {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }

    /* TODO */
    function noOfUsersInABet(string calldata nftcollection) public view returns(uint) {
        return nftToBets[nftcollection].length;
    }

    function onGoingBets() public view returns(Bet[] memory) {
        uint n = betIds.length;      
        Bet[] memory _ongoingBets = new Bet[](n);
        uint index;

        for(uint i=0; i< n; ++i){
            Bet memory bet = bets[betIds[i]];
            if(bet.status == BetStatus.AVAILABLE){
                _ongoingBets[index++] = bet;
            }
        }
        return _ongoingBets;
    }

}