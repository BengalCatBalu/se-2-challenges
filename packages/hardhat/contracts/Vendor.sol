pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfEth, uint256 amountOfTokens);

  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;


  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() external payable {
    uint256 amount = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, amount);
    emit BuyTokens(msg.sender, msg.value, amount);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() external onlyOwner {
    //yourToken.transfer(owner(), yourToken.balanceOf(address(this)));
    payable(owner()).transfer(address(this).balance);
  }
  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 amount) external {
        //require(msg.sender != owner(), "To keep Liquidity, we restrict to sell funds for owner");
        require(address(this).balance >= amount / tokensPerEth, "Vendor: insufficient funds");
        yourToken.transferFrom(msg.sender, address(this), amount);

        payable(msg.sender).transfer(amount / tokensPerEth);
        emit SellTokens(msg.sender,amount / tokensPerEth, amount );
  }
}
