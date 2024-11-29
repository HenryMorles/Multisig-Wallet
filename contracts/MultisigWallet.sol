// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultisigWallet {

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public requiredSignatures;

    struct Transaction {
    address to;
    uint value;
    bytes data;
    bool executed;
    uint confirmations;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;

    struct OwnerChangeRequest {
    address owner;
    bool isAdding;
    uint confirmations;
    bool executed;
    }

    OwnerChangeRequest[] public ownerChangeRequests;
    mapping(uint => mapping(address => bool)) public ownerChangeConfirmations;

    event TransactionCreated(uint indexed txIndex, address indexed to, uint value, bytes data);
    event TransactionConfirmed(uint indexed txIndex, address indexed owner);
    event TransactionExecuted(uint indexed txIndex);
    
    event Deposit(address indexed sender, uint value);

    event OwnerChangeRequestCreated(uint indexed requestIndex, address indexed owner, bool isAdding);
    event OwnerChangeRequestConfirmed(uint indexed requestIndex, address indexed confirmer);
    event OwnerChangeRequestExecuted(uint indexed requestIndex, address indexed owner, bool isAdding);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint _txIndex) {
    require(_txIndex < transactions.length, "Transaction does not exist");
    _;
    }

    modifier notExecuted(uint _txIndex) {
    require(!transactions[_txIndex].executed, "Transaction already executed");
    _;
    }

    modifier notConfirmed(uint _txIndex) {
    require(!confirmations[_txIndex][msg.sender], "Transaction already confirmed");
    _;
    }

    constructor(address[] memory _owners) {
        require(_owners.length > 0, "Owners required");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address");
            require(!isOwner[owner], "Owner not unique");
            isOwner[owner] = true; 
            owners.push(owner);
        }

        requiredSignatures = owners.length / 2 + 1;
    }

    receive() external payable {
    emit Deposit(msg.sender, msg.value);
    }

    function getBalance() public view returns (uint) {
    return address(this).balance;
    }

    function createTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
        }));

        emit TransactionCreated(transactions.length - 1, _to, _value, _data);
    }

    function confirmTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {

        Transaction storage transaction = transactions[_txIndex];
    
        confirmations[_txIndex][msg.sender] = true;
        transaction.confirmations += 1;

        if (transaction.confirmations >= requiredSignatures) {
            transaction.executed = true;

            (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
            require(success, "Transaction failed");

            emit TransactionExecuted(_txIndex);
        }
    }

    function getTransaction(uint _txIndex) public view returns (address to, uint value, bytes memory data, bool executed, uint confirmationsCount) {

        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.confirmations
        );
    }

    function createOwnerChangeRequest(address _owner, bool _isAdding) public onlyOwner {
        require(_owner != address(0), "Invalid owner address");
        require(isOwner[_owner] != _isAdding, "Redundant request");

        ownerChangeRequests.push(OwnerChangeRequest({
            owner: _owner,
            isAdding: _isAdding,
            confirmations: 0,
            executed: false
        }));

        emit OwnerChangeRequestCreated(ownerChangeRequests.length - 1, _owner, _isAdding);
    }

    function confirmOwnerChangeRequest(uint _requestIndex) public onlyOwner {
        require(_requestIndex < ownerChangeRequests.length, "Request does not exist");
        OwnerChangeRequest storage request = ownerChangeRequests[_requestIndex];
        require(!request.executed, "Request already executed");
        require(!ownerChangeConfirmations[_requestIndex][msg.sender], "Request already confirmed");

        ownerChangeConfirmations[_requestIndex][msg.sender] = true;
        request.confirmations += 1;

         emit OwnerChangeRequestConfirmed(_requestIndex, msg.sender);

        if (request.confirmations >= requiredSignatures) {
            request.executed = true;

            if (request.isAdding) {
               owners.push(request.owner);
                isOwner[request.owner] = true;
            } else {
                require(isOwner[request.owner], "Owner does not exist");
                isOwner[request.owner] = false;

                for (uint i = 0; i < owners.length; i++) {
                    if (owners[i] == request.owner) {
                        owners[i] = owners[owners.length - 1];
                        owners.pop();
                        break;
                    }
                }
           }

            requiredSignatures = owners.length / 2 + 1;

            emit OwnerChangeRequestExecuted(_requestIndex, request.owner, request.isAdding);
        }
    }

    function getAllTransactions() public view returns (Transaction[] memory) {
    return transactions;
    }

}
