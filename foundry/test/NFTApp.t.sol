// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/NFTApp.sol";
import "../src/PlatformToken.sol";

interface CheatCodes {
    function startPrank(address) external;
    function stopPrank() external;
}

contract NFTAppTest is DSTest {
    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);

    NFTApp public NFTAppObj;
    PlatformToken public token;
    string public artUris;
    address public addr;

    function setUp() public {
        addr = 0x1234567890123456789012345678901234567890;
        token =new PlatformToken();
        NFTAppObj = new NFTApp(address(token), "NFTApp", "NFTA");
    }
    
    // test mint and NFT token cost worth of tokens credit to contract account
    function testMint() public {
        token.approve(address(NFTAppObj), 1000 ether);
        NFTAppObj.transferTokensToUser(addr, 100 ether);
        emit log_uint(NFTAppObj.getUserTokenBalance(addr));
        cheats.startPrank(address(addr));
        token.approve(address(NFTAppObj), 100 ether);
        NFTAppObj.mint("ipfs://QmRAakxqsTJqGAhd5yd3iip4fEL7KMZanTaxLH9k2wHqND");
        cheats.stopPrank();
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
