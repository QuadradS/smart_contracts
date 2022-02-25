pragma solidity >=0.7.0;

contract Transfer {
    uint public allReceivedMoney;

    function receiveMoney() public payable {
        allReceivedMoney += msg.value;
    }

    function getBalance () public view returns (uint) {
        return address(this).balance;
    }

    function getAddress () public view returns (address) {
        address currentAddress = address(this);
        return currentAddress;
    }

    function withDraw() public {
        address payable sender = msg.sender;
        sender.transfer(getBalance());
    }

    function transferTo (address payable _to, uint _count) public {
        _to.transfer(_count);
    }
}