// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import './PriceConverter.sol';

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18; //'const' save gas

    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner; //'immutable' save gase

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough ETH!"); //1e18 == 1 * (10**18) = 1000000000000000000
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {

        for( uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++ ){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset array
        funders = new address[](0); 

        //transfer
        // payable (msg.sender).transfer(address(this).balance);

        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed!");

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        revert();
    }
    modifier onlyOwner {
        if(msg.sender != i_owner) {revert NotOwner();} //save gas
        //require(msg.sender == i_owner, "Sender is not owner!");
        _;
    }
    //receive
    receive() external payable {
        fund();
    }
    //fallback
    fallback() external payable {
        fund();
    }
}



