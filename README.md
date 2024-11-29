# **Multisig Wallet**

## 📝 Project Description

The **Multisig Wallet** is a smart contract that enables secure, multi-signature transactions on the Ethereum blockchain. 
It ensures that a group of owners can collectively manage funds and approve transactions, making it ideal for DAOs, families, or businesses.

---

## 🚀 Features

- **Multi-Signature Security**: Transactions require a minimum number of approvals (M-of-N model).
- **Owner Management**: Owners can be added or removed via voting.
- **ERC20 Token Support**: Create transactions for token transfers.
- **Emergency Pause**: Ability to pause all transactions.
- **Flexible Execution**: Transactions are automatically executed once enough approvals are collected.
- **Gas Efficiency**: Optimized for minimal gas usage.

---

## 🛠️ Installation

### Prerequisites

- **Node.js** (Latest LTS version)
- **Hardhat** (Ethereum development environment)
- **Metamask** (for interaction with deployed contracts)

### Steps

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd Multisig_Wallet
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Compile the smart contracts:

   ```bash
   npx hardhat compile
   ```

4. Deploy the smart contracts:

   ```bash
   npx hardhat run scripts/deploy.js --network <network-name>
   ```

---

## 📜 Smart Contract Structure

### Main Contract: `MultisigWallet.sol`

- **Constructor**:
  Initializes the wallet with a list of owners and calculates the required signatures.

- **Core Functions**:
  - `createTransaction`: Propose a transaction.
  - `confirmTransaction`: Approve a proposed transaction.
  - `executeTransaction`: Execute an approved transaction.

- **Owner Management**:
  - `createOwnerChangeRequest`: Propose to add/remove an owner.
  - `confirmOwnerChangeRequest`: Approve the proposal.

---

## 📄 Testing

Run tests to ensure the functionality is correct:

```bash
npx hardhat test
```

Tests are located in the `/test` folder and cover all major functionalities.

---

## 📂 File Structure

- `contracts/`: Solidity source files.
- `test/`: Test cases for the smart contracts.
- `scripts/`: Deployment scripts.

---

## 🌐 Links

- [GitHub Repository](https://github.com/your-repository-link)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Solidity Documentation](https://docs.soliditylang.org/)

---

## 💡 Ideas for Improvement

1. Implement a UI for easy interaction.
2. Add support for more ERC standards (e.g., ERC721).
3. Enable multi-network deployments (e.g., Polygon, Binance Smart Chain).

---

## 🛡️ License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## ✨ Contributors

Feel free to contribute to this project by forking the repository and submitting a pull request.
