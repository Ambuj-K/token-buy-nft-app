// SPDX-License-Identifier: MIT

pragma solidity >=0.8.9;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

//Error Types
error NFTApp_TokensNotEnough(); 
error NFTApp__LowTokenUser();
error NFTApp__TokenTransferToUserFailed();
error NFTApp__TokenTransferToNFTContractFailed();
error NFTApp__NotOwner();

contract NFTApp is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {

  // Staking token used by the app
  IERC20 public s_NFTToken;

  address public owner_addr;

  // Counter for token id counter
  using Counters for Counters.Counter;  
  Counters.Counter internal s_tokenIdCounter;

  // art uri address
  string internal s_artURI;

  // reward rate per second is 100
  uint256 internal constant NFT_TOKEN_RATE = 100;

  // events
  event NFTApp__NFTMintToUserSuccess(address, string);

  constructor(
    address _tokenAddress,
    string memory _artURI,
    string memory _tokenName,
    string memory _tokenSymbol
  ) ERC721(_tokenName, _tokenSymbol) {

    owner_addr = msg.sender;
    s_NFTToken = IERC20(_tokenAddress);
    s_artURI = _artURI;

  }

  function transferTokensToUser(address user_addr, uint256 _amount) public returns(bool){
    bool success = s_NFTToken.transferFrom(owner_addr, user_addr, _amount);
    if (!success){
      revert NFTApp__TokenTransferToUserFailed();
    }
    return true;
  }

  function getUserTokenBalance(address user_addr) public view returns(uint256){ 
    return s_NFTToken.balanceOf(user_addr);// balanceOf function is already declared in ERC20 token function
  }

  function approveTokensForContract(uint256 _tokenamount) public returns(bool){
    bool success  = s_NFTToken.approve(address(this), _tokenamount);
    if (!success){
      revert NFTApp__TokenTransferToUserFailed();
    }
    return true;
  }

  function getAllowance() public view returns(uint256){
       return s_NFTToken.allowance(msg.sender, address(this));
  }

  function mint(address to) external {

    uint256 tokenId = s_tokenIdCounter.current();
    s_tokenIdCounter.increment();

    if(getAllowance() < NFT_TOKEN_RATE*1e18){
      revert NFTApp__LowTokenUser();
    }
    else{
      // IERC transfer function to take NFTToken from sender to this contract
      // bool success = s_NFTToken.transferFrom(msg.sender, address(this), NFT_TOKEN_RATE);

      // require string is gas expensive, so custom descriptive error


      bool success = s_NFTToken.transferFrom(msg.sender, address(this), NFT_TOKEN_RATE * 1e18);
      if (!success){
        revert NFTApp__TokenTransferToNFTContractFailed();
      }
      _safeMint(to, tokenId);
      _setTokenURI(tokenId, s_artURI);

      emit NFTApp__NFTMintToUserSuccess(to, s_artURI);
    }
  }

  function getContractTokenBalance() public onlyOwner view returns(uint256){
    return s_NFTToken.balanceOf(address(this));
  }

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(tokenId);
  }

  function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
  {
    return super.tokenURI(tokenId);
  }

}