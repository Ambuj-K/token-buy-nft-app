// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/NFTApp.sol";
import "../src/PlatformToken.sol";

contract NFTAppTest is DSTest {
    NFTApp public NFTAppObj;
    PlatformToken public token;
    string public artUris;
    address public addr;

    function setUp() public {
        addr = 0x1234567890123456789012345678901234567890;
        token =new PlatformToken();
        artUris = "ipfs://QmRAakxqsTJqGAhd5yd3iip4fEL7KMZanTaxLH9k2wHqND";
        NFTAppObj = new NFTApp(address(token), artUris, "NFTApp", "NFTA");
    }
    
    // test mint and NFT token cost worth of tokens credit to contract account
    function testMint() public {
        token.approve(address(NFTAppObj), 1000 ether);
        NFTAppObj.transferTokensToUser(addr,100 ether);
        NFTAppObj.mint(addr);
        emit log_uint(NFTAppObj.getContractTokenBalance());
        assertEq(NFTAppObj.getContractTokenBalance(),100 ether);
    }

    // test transferring tokens to users
    function testTransferTokens() public {
        // NFTAppObj.approveTokensForContract(100 ether);
        token.approve(address(NFTAppObj), 1000 ether);
        NFTAppObj.transferTokensToUser(addr,100 ether);
        emit log_uint(NFTAppObj.getContractTokenBalance());
        assertEq(NFTAppObj.getUserTokenBalance(addr),100 ether);
    }


}
