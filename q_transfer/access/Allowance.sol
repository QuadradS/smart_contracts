import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

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
