// SPDX-License-Identifier: MIT

pragma solidity >=0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

// Error Types
// "require" string is gas expensive, so custom descriptive error
error NFTApp__LowTokenUser();
error NFTApp__TokenTransferToUserFailed();
error NFTApp__TokenTransferToNFTContractFailed();

contract NFTApp is ERC721URIStorage, Ownable, ReentrancyGuard {

  // Staking token used by the app
  IERC20 internal s_NFTToken;

  // Owner address
  address internal owner_addr;

  // Counter for token id counter
  using Counters for Counters.Counter;  
  Counters.Counter internal s_tokenIdCounter;

  // Reward rate per second is 100
  uint256 internal constant NFT_TOKEN_RATE = 100;

  // Events
  event NFTApp__NFTMintToUserSuccess(address, string);
  event NFTApp__TokensTransferredToUser(address, uint256);

  constructor(
    address _tokenAddress,
    string memory _tokenName,
    string memory _tokenSymbol
  ) ERC721(_tokenName, _tokenSymbol) {

    owner_addr = msg.sender;
    s_NFTToken = IERC20(_tokenAddress);

  }

  // Transfer tokens to user
  function transferTokensToUser(address user_addr, uint256 _amount) public nonReentrant returns(bool) {
    bool success = s_NFTToken.transferFrom(owner_addr, user_addr, _amount);
    if (!success){
      revert NFTApp__TokenTransferToUserFailed();
    }
    emit NFTApp__TokensTransferredToUser(user_addr, _amount);
    return true;
  }

  // Get user token balance
  function getUserTokenBalance(address user_addr) public view returns(uint256){ 
    return s_NFTToken.balanceOf(user_addr);
  }

  // Mint art uri to address
  function mint(address to, string memory art_uri) external nonReentrant {

    uint256 tokenId = s_tokenIdCounter.current();
    s_tokenIdCounter.increment();

    if(getUserTokenBalance(msg.sender) < NFT_TOKEN_RATE*1e18){
      revert NFTApp__LowTokenUser();
    }
    else{

      bool success = s_NFTToken.transferFrom(msg.sender, address(this), NFT_TOKEN_RATE * 1e18);
      if (!success){
        revert NFTApp__TokenTransferToNFTContractFailed();
      }
      _safeMint(to, tokenId);
      _setTokenURI(tokenId, art_uri);

      emit NFTApp__NFTMintToUserSuccess(to, art_uri);
    }
  }

  // contracts token count response
  function getContractTokenBalance() public onlyOwner view returns(uint256){
    return s_NFTToken.balanceOf(address(this));
  }

  // get
  function getPerTokenValue() public pure returns(uint256){
    return NFT_TOKEN_RATE;
  }
}