// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./TokenA.sol";
import "./TokenB.sol";

contract MiniDEX {
    TokenA public tokenA;
    TokenB public tokenB;
    
    uint256 public reserveA;
    uint256 public reserveB;
    uint256 public totalLiquidity;
    
    mapping(address => uint256) public liquidityBalance;

    // SWAP FEE MECHANISM (0.3%)
    uint256 public constant FEE_NUMERATOR = 997; // 0.3% fee = 3/1000
    uint256 public constant FEE_DENOMINATOR = 1000;

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidityMinted);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB, uint256 liquidityBurned);
    event Swap(address indexed user, uint256 amountAIn, uint256 amountBIn, uint256 amountAOut, uint256 amountBOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = TokenA(_tokenA);
        tokenB = TokenB(_tokenB);
    }

    // ฟังก์ชันช่วยคำนวณรากที่สอง (Square Root) สำหรับคำนวณ LP ตอน Add Liquidity ครั้งแรก
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be greater than zero");

        // ดึง Token จากผู้ใช้เข้าสู่ DEX (ผู้ใช้ต้องเรียก approve ก่อน)
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Transfer TokenA failed");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Transfer TokenB failed");

        uint256 liquidityMinted;

        if (totalLiquidity == 0) {
            // If first liquidity provider
            liquidityMinted = sqrt(amountA * amountB);
        } else {
            // Else: ต้องตรวจอัตราส่วนให้ตรงกับ Pool
            require(amountA * reserveB == amountB * reserveA, "Wrong pool ratio");
            liquidityMinted = (amountA * totalLiquidity) / reserveA;
        }

        // อัปเดตข้อมูลผู้ใช้และพูล
        liquidityBalance[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;
        reserveA += amountA;
        reserveB += amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB, liquidityMinted);
    }

    function removeLiquidity(uint256 liquidityAmount) external {
        require(liquidityAmount > 0, "Amount must be greater than zero");
        require(liquidityBalance[msg.sender] >= liquidityAmount, "Insufficient liquidity balance");

        // คำนวณ TokenA และ TokenB ที่ต้องคืนให้ผู้ใช้ตามสัดส่วน
        uint256 amountA = (liquidityAmount * reserveA) / totalLiquidity;
        uint256 amountB = (liquidityAmount * reserveB) / totalLiquidity;

        // อัปเดตข้อมูลผู้ใช้และพูล
        liquidityBalance[msg.sender] -= liquidityAmount;
        totalLiquidity -= liquidityAmount;
        reserveA -= amountA;
        reserveB -= amountB;

        // ส่งโทเคนคืนให้ผู้ใช้
        require(tokenA.transfer(msg.sender, amountA), "Transfer TokenA failed");
        require(tokenB.transfer(msg.sender, amountB), "Transfer TokenB failed");

        emit LiquidityRemoved(msg.sender, amountA, amountB, liquidityAmount);
    }

    function swapAforB(uint256 amountAIn) external {
        require(amountAIn > 0, "Amount must be greater than zero");
        require(reserveA > 0 && reserveB > 0, "Pool is empty");

        // Apply 0.3% swap fee
        uint256 amountAInWithFee = (amountAIn * FEE_NUMERATOR) / FEE_DENOMINATOR;
        
        // Calculate amountBOut
        uint256 amountBOut = (reserveB * amountAInWithFee) / (reserveA + amountAInWithFee);
        require(amountBOut > 0 && amountBOut < reserveB, "Insufficient liquidity for swap");

        // Transfer FULL amountAIn of TokenA into the contract
        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Transfer TokenA failed");
        
        // Transfer amountBOut of TokenB to msg.sender
        require(tokenB.transfer(msg.sender, amountBOut), "Transfer TokenB failed");

        // Update reserves (จํานวน input เต็มถูกเก็บใน reserve เพื่อให้เป็นประโยชน์แก่ LP)
        reserveA += amountAIn;
        reserveB -= amountBOut;

        emit Swap(msg.sender, amountAIn, 0, 0, amountBOut);
    }

    function swapBforA(uint256 amountBIn) external {
        require(amountBIn > 0, "Amount must be greater than zero");
        require(reserveA > 0 && reserveB > 0, "Pool is empty");

        // Symmetric to swapAforB (TokenB in -> TokenA out with fee)
        uint256 amountBInWithFee = (amountBIn * FEE_NUMERATOR) / FEE_DENOMINATOR;
        
        uint256 amountAOut = (reserveA * amountBInWithFee) / (reserveB + amountBInWithFee);
        require(amountAOut > 0 && amountAOut < reserveA, "Insufficient liquidity for swap");

        require(tokenB.transferFrom(msg.sender, address(this), amountBIn), "Transfer TokenB failed");
        require(tokenA.transfer(msg.sender, amountAOut), "Transfer TokenA failed");

        reserveB += amountBIn;
        reserveA -= amountAOut;

        emit Swap(msg.sender, 0, amountBIn, amountAOut, 0);
    }

    function getPriceOfAinB() external view returns (uint256) {
        require(reserveA > 0, "No liquidity");
        // Return price of 1 TokenA in TokenB (with 18 decimals precision)
        return (reserveB * 1e18) / reserveA;
    }
}