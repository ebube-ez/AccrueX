# AccrueX

## Overview

**AccrueX** is a **token-based loyalty program** built in **Clarity**. It enables businesses to issue, manage, and redeem loyalty tokens for users, promoting customer engagement through an on-chain reward system. Users can earn, transfer, and redeem tokens for available rewards, while the contract owner manages token issuance and reward inventory.

## Key Features

* **Tokenized Rewards System:** Issues loyalty tokens that users can earn and spend.
* **Reward Catalog Management:** Admins can add rewards with customizable names, costs, and availability counts.
* **Secure Token Transfers:** Allows peer-to-peer transfers between participants with strict authorization checks.
* **Redemption Mechanism:** Users can redeem rewards directly on-chain by spending accumulated tokens.
* **Transparent Balance Tracking:** Every user’s token balance and reward availability are publicly verifiable through read-only functions.

## Contract Components

### Data Maps

* **balances:** Stores each participant’s loyalty token balance.
* **rewards:** Tracks available rewards with attributes such as name, cost, and quantity.

### Variables

* **token-name / token-symbol:** Define the loyalty token’s identity.
* **owner:** Stores the contract administrator authorized to mint tokens and add rewards.
* **reward-counter:** Tracks the number of registered rewards.

### Error Constants

Defines standard error codes for common validation issues, including unauthorized access, insufficient balance, invalid parameters, and unavailable rewards.

### Core Functions

* **(transfer amount sender recipient):** Transfers tokens between users after verifying authorization and sufficient balance.
* **(mint amount recipient):** Allows the contract owner to issue new tokens to a user’s balance.
* **(add-reward name cost available):** Enables the owner to list a new reward with its required token cost and available quantity.
* **(redeem-reward reward-id):** Deducts tokens from a user’s balance and updates the reward’s availability upon redemption.

### Read-Only Functions

* **(get-name):** Returns the loyalty token’s name.
* **(get-symbol):** Returns the token’s symbol.
* **(get-balance account):** Displays a user’s current token balance.
* **(get-reward reward-id):** Retrieves details of a specific reward by ID.

## Summary

**AccrueX** provides a transparent and efficient framework for blockchain-based loyalty programs. With features for secure token management, automated reward redemption, and on-chain accounting, it enables businesses to incentivize participation and reward users without intermediaries.
