# NFT Futures betting
## IDEA
<p align="justify"> NFT Futures betting is a decentralized application where two users can bet on the future price of NFTs. Results will be published within one hour after each wager is made. The rewards from the betting get credited to the winners wallet. </p>

## PROBLEM
<p align="justify">In a Web 2.0 world, future bettings are controlled by a centralized betting authority or an organization. A corrupt organization can lead to loss of assets. It is difficult to establish trust in these companies and the payment gateways they use.  Know Your Customer (KYC) check is used by the existing betting companies to identify and verify the client's identity when opening an account and periodically over time. The anonymity of the user is lost. Using the power of blockchain, we hope to remove centralized authority and replace it with smart contracts. Users are completely anonymous in our dApp and no personal identifiable information will be collected or stored. </p>

<p align="justify">2021 has seen the rise of NFTs as an asset class. They brought a lot of excitement and enthusiasm in the cryptospace. Opensea, one of the leading NFT marketplaces, even saw trading volume cross over 450 million dollars in a single day. The Opensea trading volume declined since then correlating to the overall macroeconomic conditions. A lot of NFT sets floor prices crumbled in the recent slump. This shows that NFTs as an asset class is still in its nascent phase. NFT Futures is a fun way of speculating on NFTs without holding any NFT. We believe once the market matures more people would be speculating on the prices of these assets.  </p>

<!-- ![Architecture Diagram](https://github.com/AgastyaTeja/NFT-Futures/blob/main/public/NFT-futures%20Betting%20White%20Paper.jpg) -->

![Architecture Diagram](https://github.com/AgastyaTeja/NFT-Futures/blob/main/public/NFT-futures%20Betting%20White%20Paper.jpg)

## CORE FEATURES AND FUNCTIONALITIES
1. User Authentication
  - Our dApp users need to have Metamask inorder to login and participate in NFT betting. On successful authentication, users will be redirected to our betting home page.
2. Betting on NFT sets
  - Betting is open to users for 10 min after every 1 hour of wait time. During the 1 hour of the wait time users are not allowed to bet and change their bets. 
  - User predicts the closet floor price of an NFT set in the next hour. 
  - Users can place multiple bets within 10 min across multiple NFT sets or the same Set. 
  - Each Bet cost 0.1 eth for the user.
  - If only one user placed a bet then the user gets the fund returned to their wallet after the betting window closes.
3. History of Bets
  - List all the on-going bets of the user.
  - List past bets the user participated in with the details of the bet and winner. 
