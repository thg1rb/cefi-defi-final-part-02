// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenB {
    string public name = "Beta Token";
    string public symbol = "BETA";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        _mint(msg.sender, 1_000_000 * 10**18); // 1 million BETA to deployer
    }

    function _mint(address to, uint256 amount) internal {
        balanceOf[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    // ฟังก์ชันสำหรับโอนโทเคนไปยัง address อื่น
    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");
        
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // ฟังก์ชันสำหรับอนุญาตให้ address อื่นดึงโทเคนไปใช้
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // ฟังก์ชันสำหรับดึงโทเคนที่ได้รับอนุญาตแล้วไปใช้งาน
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "ERC20: transfer amount exceeds balance");
        require(allowance[from][msg.sender] >= amount, "ERC20: insufficient allowance");

        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }
}