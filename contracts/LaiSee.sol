// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.20;

// a library for performing various math operations

library Math {
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
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
}

contract LaiSee {
    address payable public owner;

    uint public LaiSeeCount = 1;

    uint public TotalLaiSeeAmount = 2;

    event LaiSeeEvent(address indexed recipient, uint LaiseeAmount, uint LaiseeCount, uint timestamp);

    constructor() payable {
        owner = payable(msg.sender);
    }

    modifier balanceCheck() {
        require(address(this).balance > 0, "contract balance is 0");
        _;
    }

    function OpenLaiSee() public payable balanceCheck returns (uint) {
        // get the last three digits of the timestamp
        uint base = block.timestamp % 1000;
        // sqrt(base) * 10^14 = LaiSeeAmount
        uint LaiSeeAmount = (Math.sqrt(base) / LaiSeeCount) * 10 ** 14; 
        
        // if LaiSeeAmount is less than 0.0001, set it to 0.0001 ether
        if (LaiSeeAmount <= 200000000000000) {
            LaiSeeAmount = 200000000000000;
        }

        // if LaiSeeAmount is greater than the contract balance, set it to the contract balance
        if (LaiSeeAmount > address(this).balance) {
            LaiSeeAmount = address(this).balance;
        }

        // transfer the LaiSeeAmount to the sender
        require(payable(msg.sender).send(LaiSeeAmount), "transfer failed");
        emit LaiSeeEvent(msg.sender, LaiSeeAmount, LaiSeeCount, block.timestamp);
        TotalLaiSeeAmount += LaiSeeAmount;
        LaiSeeCount++;
        return LaiSeeAmount;
    }

    function depositETH() public payable {
        // deposit ether to the contract
    }

    function withdrawETH() public {
        // withdraw all ether from the contract
        require(owner.send(address(this).balance), "transfer failed");
    }
}