pragma solidity ^0.8.0;
import "./access/Allowance.sol";

contract Allowance is Ownable {

  event AllowanceChanged(address indexed _who, address indexed _by, uint _v, uint _nv);

  mapping(address => uint) public allowance;

  modifier ownerAndAllowance(uint _amount) {
    require(isOwner() || allowance[msg.sender] >= _amount, "Not allowance");
    _;
  }

  function isOwner() public view returns (bool) {
    return owner() == msg.sender;
  }

  function addAllowance(address _to, uint _amount) public onlyOwner {
    emit AllowanceChanged(_to, msg.sender, allowance[_to], _amount);
    allowance[_to] = _amount;
  }

  function reduceAllowance(address _to, uint _amount) internal {
    emit AllowanceChanged(_to, msg.sender, allowance[_to], allowance[_to] - _amount);
    allowance[_to] -= _amount;
  }
}

contract Wallet is Allowance {

  event ReceivedMoney (address indexed _from, uint indexed _amount);
  event SentMoney (address indexed _from, uint indexed _amount);

  function withDraw(address payable _to, uint _amount) public payable ownerAndAllowance(_amount) {

    require(_amount <= address(this).balance, "Not enough tokens");

    if (!isOwner()) {
      reduceAllowance(_to, _amount);
    }

    _to.transfer(_amount);
  }

  function renounceOwner () public onlyOwner {
    revert("Can't renounce here");
  }

  function balanceOf() public view returns (uint) {
    return address(this).balance;
  }

  fallback() external payable {

  }

}
