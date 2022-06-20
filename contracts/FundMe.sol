//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }


    function fund() public payable {
        //Setting minimum amount to fund in USD
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't Send Enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; // we give += so that the balance increases if the same account funds again
    }

    function withdraw() public onlyOwner {
        
        for(uint256 funderIndex = 0;funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; // here we are resetting it back to 0 all the funds
        }
        //reset an array
        funders = new address[](0);      
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess,"Call failed!");

    }

    modifier onlyOwner {
        require(msg.sender == i_owner, "Sender is not Owner!!");
        _;  //this means continue with the rest of the code
    }

    //If the user makes transaction without giving fund , we automatically revert them to fund fucntion

    //when no data is there in the transact
    receive() external payable {
        fund();
    }

    //when there is data in the transact
    fallback() external payable {
        fund();
    }


}