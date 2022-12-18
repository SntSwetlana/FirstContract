// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import './SimpleStorage.sol';

contract ExtraSorage is SimpleStorage {
    // + 5 
    //override
    //virtual override
    function store( uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}