<h1 align="center">
  <br>
  <img src="https://www.coinmetro.com/_next/static/media/ETH.7f19530c.svg" alt="etheruem-icon" width="200" >
  <br>
  <br>
  <span>Mini Decentralized Exchange</span>
  <br>
</h1>

<p align="center">A lightweight Automated Market Maker for decentralized token swapping.</p>

## 🎯 Objective

This project is part of the Final Examination (Part 2) for the course 01418496 CeFi/DeFi. The objective is to build and develop a Mini Decentralized Exchange (Mini-DEX) as an Automated Market Maker (AMM) using the Constant-Product formula, similar to Uniswap V2. The system is designed to be deployed and tested on the Sepolia Testnet with the following core functionalities:

- To allow users to add and remove liquidity for two mock ERC-20 tokens (TokenA and TokenB) created within the system.

- To enable users to swap between the two tokens, maintaining price equilibrium through the Constant-Product Invariant formula.

- To implement a 0.3% swap fee mechanism. The collected fees remain in the liquidity pool to generate yield and increase the overall value for Liquidity Providers (LPs).

## 🛠️ Tech. Stacks.

| Layer        | Technology              |
|--------------|------------------------|
| Language     | Solidity                   |
| Network      | Ethereum (Sepolia Testnet)     |
| Web3 Wallet   | MetaMask               |
| Editor   | Remix IDE               |

## 📁 File Descriptions

### 1. [`TokenA.sol`](https://sepolia.etherscan.io/address/0x146253E4e33F68b7866d26F257352a92c03DD442)

A Smart Contract for creating the first standard ERC-20 token used in the DEX testing environment.

- Token Features: Name: "Alpha Token" (Symbol: ALPHA) with 18 decimal places.

- Minting: Upon deployment, the contract automatically mints 1,000,000 ALPHA tokens directly to the deployer's wallet.

- Functionality: Supports standard ERC-20 functions including transfer, approve, and transferFrom. It operates with zero transfer fees to ensure seamless integration with the DEX.

### 2. [`TokenB.sol`](https://sepolia.etherscan.io/address/0xc8a09842bdD879fCFeAB0B86E14d320cA9453613)

A Smart Contract for creating the second standard ERC-20 token, mirroring the exact structure and behavior of TokenA.

- Token Features: Name: "Beta Token" (Symbol: BETA) with 18 decimal places.

- Minting: Upon deployment, the contract automatically mints 1,000,000 BETA tokens to the deployer's wallet.

- Functionality: Provides basic ERC-20 functions, acting as a trading pair for swapping and providing liquidity alongside TokenA.

### 3. [`MiniDEX.sol`](https://sepolia.etherscan.io/address/0x77AF448d9ad535642786565c6D6d03D26940e480)

The core Smart Contract functioning as the Decentralized Exchange (DEX).

- Liquidity Management (addLiquidity / removeLiquidity): * The initial liquidity provider determines the starting price ratio of the pool.

    - Subsequent liquidity providers must strictly deposit tokens in proportion to the current pool reserves.

    - The system calculates and mints LP (Liquidity Provider) tokens to track fractional ownership of the pool. Users can burn their LP tokens to withdraw their proportional share of TokenA and TokenB.

- Swap Mechanism (swapAforB / swapBforA): Supports two-way token swaps, utilizing the Constant-Product Invariant to calculate the exact output amount for the user.

    - Fee Mechanism: A 0.3% fee is deducted from every swap transaction (calculated as 997/1000). These deducted tokens remain locked in the pool reserves, thereby increasing the underlying value of the pool for all LPs.

- Price Checking (getPriceOfAinB): Includes a read-only function to check the current price of 1 TokenA relative to TokenB based on the real-time state of the pool reserves.

## Transaction History (Sepolia Testnet)

The table below displays the history and evidence of all transactions executed during the system testing phase:

| Transaction        | Description             | Transaction Hash  |
|--------------|------------------------|----------|
| Deploy TokenA |	Deploy the Smart Contract for TokenA |	[0x146253E4e33F68b7866d26F257352a92c03DD442](https://sepolia.etherscan.io/address/0x146253E4e33F68b7866d26F257352a92c03DD442)  |
| Deploy TokenB |	Deploy the Smart Contract for TokenB |	[0xc8a09842bdD879fCFeAB0B86E14d320cA9453613](https://sepolia.etherscan.io/address/0xc8a09842bdD879fCFeAB0B86E14d320cA9453613) |
| Deploy MiniDEX |	Deploy the core DEX Smart Contract | [0x77AF448d9ad535642786565c6D6d03D26940e480](https://sepolia.etherscan.io/address/0x77AF448d9ad535642786565c6D6d03D26940e480) |
| Approve Tokens |	Allow MiniDEX to spend TokenA and TokenB |	[TokenA: 0xe6b565c856ad5000e5e5f51d742c87e5f8c2757ee3e34bfe6eee5beb9e6074ea](https://sepolia.etherscan.io/tx/0xe6b565c856ad5000e5e5f51d742c87e5f8c2757ee3e34bfe6eee5beb9e6074ea) <br> [TokenB: 0x5acbf155ce15004e459c4fd350de1816a67a03246857b53b620ae7df55b1c74c](https://sepolia.etherscan.io/tx/0x5acbf155ce15004e459c4fd350de1816a67a03246857b53b620ae7df55b1c74c)  |
| Add Liquidity	| Add initial liquidity to the pool | [0x600cd045d625d0b307396f631c976700d1d485e2a87874bb5e388de9efdca668](https://sepolia.etherscan.io/tx/0x600cd045d625d0b307396f631c976700d1d485e2a87874bb5e388de9efdca668) |
| Remove Liquidity	| Withdraw liquidity and receive accumulated fees |	[0x477153e50a84f04790fd46187118a7addfa6a9159dd5707dc859d9ec78af93cc](https://sepolia.etherscan.io/tx/0x477153e50a84f04790fd46187118a7addfa6a9159dd5707dc859d9ec78af93cc) |
| Swap A for B |	Swap TokenA for TokenB | [0xafbe06dac689e6f6fc91fcb1f4eb50fa9802d3bf2844f7f81a2b2672473f4645](https://sepolia.etherscan.io/tx/0xafbe06dac689e6f6fc91fcb1f4eb50fa9802d3bf2844f7f81a2b2672473f4645) |
| Swap B for A |	Swap TokenB for TokenA | [0x0d6fa233d940cfbf087bbf969b551341bedc4ed126d2e982842e9031a4ff44f9](https://sepolia.etherscan.io/tx/0x0d6fa233d940cfbf087bbf969b551341bedc4ed126d2e982842e9031a4ff44f9) |