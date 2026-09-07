// SPDX-License-Identifier: MIT
pragma solidity 0.5.10;

/**
 * @title NileDemoToken
 * @notice Educational TRC-20-style token for TRON Nile Testnet only.
 * @dev This token is deliberately named NDD and does not represent USDT or any real asset.
 */
contract NileDemoToken {
    string public name = "Nile Demo Dollar";
    string public symbol = "NDD";
    uint8 public decimals = 6;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 initialSupply) public {
        owner = msg.sender;
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals)));
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Zero address");
        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function mint(address account, uint256 wholeTokens) external onlyOwner {
        _mint(account, wholeTokens * (10 ** uint256(decimals)));
    }

    function burn(uint256 amountInBaseUnits) external {
        require(balanceOf[msg.sender] >= amountInBaseUnits, "Insufficient balance");
        balanceOf[msg.sender] -= amountInBaseUnits;
        totalSupply -= amountInBaseUnits;
        emit Transfer(msg.sender, address(0), amountInBaseUnits);
    }

    function transfer(address to, uint256 amountInBaseUnits) external returns (bool) {
        require(to != address(0), "Zero address");
        require(balanceOf[msg.sender] >= amountInBaseUnits, "Insufficient balance");
        balanceOf[msg.sender] -= amountInBaseUnits;
        balanceOf[to] += amountInBaseUnits;
        emit Transfer(msg.sender, to, amountInBaseUnits);
        return true;
    }

    function approve(address spender, uint256 amountInBaseUnits) external returns (bool) {
        allowance[msg.sender][spender] = amountInBaseUnits;
        emit Approval(msg.sender, spender, amountInBaseUnits);
        return true;
    }

    function transferFrom(address from, address to, uint256 amountInBaseUnits) external returns (bool) {
        require(to != address(0), "Zero address");
        require(balanceOf[from] >= amountInBaseUnits, "Insufficient balance");
        require(allowance[from][msg.sender] >= amountInBaseUnits, "Allowance exceeded");
        allowance[from][msg.sender] -= amountInBaseUnits;
        balanceOf[from] -= amountInBaseUnits;
        balanceOf[to] += amountInBaseUnits;
        emit Transfer(from, to, amountInBaseUnits);
        return true;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
