//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

contract NFTFuturesBetting is ChainlinkClient {

    using Chainlink for Chainlink.Request;
    using Counters for Counters.Counter;

    event RequestVolume(bytes32 indexed requestId, uint256 volume);
    address payable private owner;

    bytes32 private jobId;
    uint256 private fee;
    Counters.Counter private betCounter;
    uint private minEthBalRequired = 10000000000000000; // 0.1 ETH

    // enum of bet status
    enum BetStatus {
       AVAILABLE,
       RUNNING,
       COMPLETED,
       FAILED
    }

    /**
    map betId => corresponding bet
    For efficiency reasons Solidity/EVM does not store iterative keys, so maintain another array for keys to
    traverse through the mapping bets
    */
    mapping(uint => Bet) private bets;
    uint[] private betIds;

    // map nftId => corresponding all betIds where nftId = nftCollection_property
    mapping(string => uint[]) private nftToBets;

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

    /**
     * @notice Initialize the link token and target oracle
     *
     * Kovan Testnet details:
     * Link Token: 0xa36085F69e2889c224210F603D836748e7dC0088 0xa36085F69e2889c224210F603D836748e7dC0088
     * Oracle: 0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656 (Chainlink DevRel)
     * jobId: ca98366cc7314957b8c012c72f05aeeb
     *
     */
    constructor() payable  {
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
        setChainlinkOracle(0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656);
        jobId = 'ca98366cc7314957b8c012c72f05aeeb';
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
        owner = payable(msg.sender);
    }

    function deposit() public payable {}
    receive() external payable {
         console.log(msg.sender, msg.value);
    }

    /**
        UI calls this function to update itself with all the bets that are available.
        This function will return two associative arrays,
        1st array contains list of uints which represent betIDs
        2nd array contains list of Bet which represent bets.
    */
    function getAllBets() public view returns (uint[] memory betsKeys, Bet[] memory betsValues) {
        uint len = betIds.length;

        uint[] memory _betsKeys = new uint[](len);
        Bet[] memory _betsValues = new Bet[](len);

        for(uint i=0; i<len; ++i){
            betsKeys[i] = betIds[i];
            betsValues[i] = bets[betIds[i]];
        }

        return(_betsKeys, _betsValues);
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
        Bet[] memory allBetsOfUser;

        // Iterate on bets and add those with either user1 == sender or user2 == sender
        for(uint i=0; i<betIds.length; ++i){
            Bet memory bet = bets[betIds[i]];
            if(bet.userBid1.user == msg.sender || bet.userBid2.user == msg.sender){
                allBetsOfUser[allBetsOfUser.length] = bet;
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
        //require(msg.value >= minEthBalRequired, "Not sufficient ETH in your wallet :(");

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
        }

        require(latestBet.status != BetStatus.RUNNING, "Maximum users exceeded error");
        return latestBet;
    }

    function placeABid(string calldata nftCollection, string calldata property, uint prediction) public payable {
        console.log("Place a bid start for user:", msg.sender, ",", string(abi.encodePacked(nftCollection, property, prediction)));
        Bid memory bid = Bid({
            user: msg.sender,
            prediction: prediction
        });
        Bet memory bet = _getBet(nftCollection, property, bid);

        console.log(bet.userBid1.user, bet.userBid2.user, bet.nftCollection, bet.property);

        // tansfer money to contract address
        // If msg.data is empty => receiving address should have a receive() defined to get ETH,
        //otherwise it does a Falllback()
        (bool success,) = address(this).call{value: msg.value}("");
        require(success, "Failed to send Ether!");

        // If userBid2 exists, then bet is full, go run runBet function
        if (bet.userBid2.user != address(0)) {
            bet.status = BetStatus.RUNNING;
            console.log("Running the bet");
            console.log(bet.userBid1.user, bet.userBid2.user, bet.nftCollection, bet.property);
            _runBet(bet);
            //_runBetOnlyForTesting(); Note: Introduced for testing
        }
    }

    function _runBet(Bet memory bet) private {
        bytes32 reqId = _requestCollectionProperty(bet.nftCollection, bet.property);
        chainlinkReqToBetId[reqId] = bet.betId;
    }

    // Note: Introduced for testing
    function _runBetOnlyForTesting() private view {
        getWinner();
    }

    // Note: Introduced for testing
    function getWinner() private view {
        uint propertyValue = 5400;
        uint betId = 0;
        Bet memory bet = bets[betId];
        bet.closingPropertyValue = propertyValue;
        uint prediction1 = bet.userBid1.prediction;
        uint prediction2 = bet.userBid2.prediction;

        if (abs(int(prediction1 - propertyValue)) <= abs(int(prediction2 - propertyValue))) {
            bet.winner = bet.userBid1.user;
        } else {
            bet.winner = bet.userBid2.user;
        }

        bet.status = BetStatus.COMPLETED;
        console.log(bet.winner, bet.closingPropertyValue, prediction1, prediction2);
    }

      /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function _requestCollectionProperty(string memory nftCollection, string memory property) internal returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        // Set the URL to perform the GET request on
        //req.add('get', 'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD');
        req.add("get", string(abi.encodePacked("https://testnets-api.opensea.io/api/v1/collection/", nftCollection, "/stats/")));

        //opensea-creature/stats/ are returned as :
        //{
        //     "stats": {
        //         "one_day_volume": 0.0,
        //         "one_day_change": 0.0,
        //         "one_day_sales": 0.0,
        //         "one_day_average_price": 0.0,
        //         "seven_day_volume": 0.0,
        //         "seven_day_change": 0.0,
        //         "seven_day_sales": 0.0,
        //         "seven_day_average_price": 0.0,
        //         "thirty_day_volume": 0.0,
        //         "thirty_day_change": 0.0,
        //         "thirty_dy_sales": 0.0,
        //         "thirty_day_average_price": 0.0,
        //         "total_volume": 1.4000000000000001,
        //         "total_sales": 9.0,
        //         "total_supply": 53.0,
        //         "count": 53.0,
        //         "num_owners": 28,
        //         "average_price": 0.15555555555555556,
        //         "num_reports": 1,
        //         "market_cap": 0.0,
        //         "floor_price": 0.0099
        //     }
        // }
        // request.add("path", "RAW.ETH.USD.VOLUME24HOUR"); // Chainlink nodes prior to 1.0.0 support this format
        //req.add('path', 'RAW,ETH,USD,VOLUME24HOUR'); // Chainlink nodes 1.0.0 and later support this format
        req.add("path", string(abi.encodePacked("stats,", property)));

        // Multiply the result by 1000000000000000000 to remove decimals
        int256 timesAmount = 10**18;
        req.addInt('times', timesAmount);

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    function abs(int x) private pure returns (int) {
        return x >= 0 ? x : -x;
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 propertyValue) public recordChainlinkFulfillment(_requestId) {
        uint betId = chainlinkReqToBetId[_requestId];
        Bet memory bet = bets[betId];
        bet.closingPropertyValue = propertyValue;
        uint prediction1 = bet.userBid1.prediction;
        uint prediction2 = bet.userBid2.prediction;

        if (abs(int(prediction1 - propertyValue)) <= abs(int(prediction2 - propertyValue))) {
            bet.winner = bet.userBid1.user;
        } else {
            bet.winner = bet.userBid2.user;
        }
        (bool success,) = address(bet.winner).call{value: 2*minEthBalRequired}("");
        if (success) {
            bet.status = BetStatus.COMPLETED;
        } else {
           bet.status = BetStatus.FAILED;
        }
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public  {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), 'Unable to transfer');
    }

    /** TODO
    function noOfUsersInABet(string nftcollection, string property) public returns(uint) {
        // Use nftToBets mapping + _getNFTIds function
    }

    function onGoingBets() public returns() {
    }
    */

}
