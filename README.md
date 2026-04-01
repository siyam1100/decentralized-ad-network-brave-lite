# Decentralized Ad Network (Brave-lite)

A professional-grade marketing primitive for the decentralized web. This repository enables a "Value-for-Attention" model where advertisers lock funds in a vault, and users earn micro-payouts in ERC-20 tokens for interacting with or viewing verified content.

## Core Features
* **Advertiser Vaults:** Securely holds campaign budgets with automated "Pay-per-Action" (PPA) logic.
* **Oracle Verification:** Integrates with off-chain analytics (via Chainlink) to verify legitimate clicks/views.
* **User Rewards:** Direct, non-custodial payouts to users' wallets for their attention.
* **Flat Structure:** Single-directory layout for the Ad Campaign Manager and Reward Engine.

## Workflow
1. **Fund:** Advertiser deposits 10,000 USDC and sets a "Reward per View" (e.g., 0.01 USDC).
2. **Interact:** User views an ad. An off-chain trigger sends a verification proof to the contract.
3. **Payout:** The contract validates the proof and sends 0.01 USDC to the user instantly.

## Setup
1. `npm install`
2. Deploy `AdNetwork.sol` with the target ERC-20 payment token.
