# Hotel booking contract
Last times the hotel industry is facing numerous challenges such as low efficiencies, lack of transparency, and security issues. May be blockchain technology has the more potential to address these challenges and improve the overall operations of the hotel business. This project aims to explore the potential benefits and challenges of implementing blockchain technology in the hotel industry and identify successful decisions. The study uses a mixed-methods approach to gather data from various sources.  Perhaps this project highlights the potential of blockchain technology to revolutionize the hotel industry and bring innovation and disruption to traditional processes. As I know many travel platforms now offer the option to book flights, car rentals, e-commerce and even unique travel experiences with ETH (e.g., Sleap.io, Travala, Cryptwerk, LockTrip, Winding Tree). Suppose as more services adopt cryptocurrency, in future entire trip can be planned using Ethereum.
In that sense, I tried to create this app that exists a simple frontend to interact with the `Hotel.sol` decentralized booking system. The properties of this software
- buy tokens representing accommodation days;
- book stays via Ethereum smart contracts;
- Ethereum smart contract can solve a number of data management problems;
- refund future appointments;
- view user bookings;
- connect with MetaMask or any EIP-1193 compatible wallet;
- Interact securely via Web3 wallet;
- built with: Solidity, Hardhat, React, Web3Modal. Ethers.js
Next provides steps for viewing and checking properties for these software packages.

## Quick Start

1. Clone the repo

2. Install dependencies
```
cd frontend
npm install
```

3. Configure Contracts Hotel.json and update:
```
{
  "address": "YOUR_HOTEL_CONTRACT_ADDRESS",
  "abi": [...]
} 
```

4. Run the app
```
npm start
```

## Testing Locally 

1. Use Hardhat Network or run a local node:
```
npx hardhat node 
```

2. Then deploy:
```
npx hardhat run scripts/deploy.js --network localhost 
```

3. Update Hotel.json with the local contract address.

## Deploying

1. Set up .env file:
```
RPC_URL=https://rinkeby.infura.io/v3/YOUR_INFURA_KEY 
PRIVATE_KEY=your_wallet_private_key 
```

2. Deploy Live Demo Using Vercel. Install Vercel CLI:
```
npm install -g vercel
```

Navigate to frontend folder:
```
cd hotel-frontend 
```

Deploy:
```
vercel
```

or Deploy to Netlify. Install Netlify CLI:
```
npm install -g netlify-cli
```

Login:
```
netlify login
```

Build and deploy:
```
netlify deploy –prod
```

After deploying, update the Hotel.json contract address with your deployed one:
```
{
  "address": "0xYourDeployedHotelContractAddress",
  "abi": [ ... ]
} 
```

Then redeploy using the same command:
```
vercel
```

or
```
netlify deploy –prod
```

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-deployed-blue.svg)](https://your-username.github.io/hotel-dapp/) 
