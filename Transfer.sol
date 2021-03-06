pragma solidity >=0.7.0;
// SPDX-License-Identifier: MIT


contract Transfer {
    uint public allReceivedMoney = 0;
    uint public lastTimestamp = block.timestamp;
    address public owner;
    mapping (address => uint) public users;

    constructor () {
        owner = msg.sender;
    }

    fallback () public payable {
        lastTimestamp = block.timestamp;
        allReceivedMoney += msg.value;
        users[msg.sender] += msg.value;
    }

    function getBalance () public view returns (uint) {
        return address(this).balance;
    }

    function getUsers () public memory returns (mapping) {
        return users;
    }

    function getAddress () public view returns (address) {
        address currentAddress = address(this);
        return currentAddress;
    }

    function withDraw() public {
        checkTimestamp();
        address payable sender = msg.sender;
        sender.transfer(getBalance());
    }

    function transferTo (address payable _to, uint _count) public {
        checkTimestamp();
        _to.transfer(_count);
    }

    function checkTimestamp () private view {
        uint currentTimestamp = block.timestamp;
            if(lastTimestamp + 60 > currentTimestamp){
                revert("A minute has not passed since the last transaction");
            }
        }
    }