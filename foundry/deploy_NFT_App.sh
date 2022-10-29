#!/usr/bin/env bash

# Read the RPC URL
echo Enter Your RPC URL:
echo Example: "https://eth-goerli.alchemyapi.io/v2//XXXXXXXXXX"
read -s rpc

# Read the contract name
echo Which contract do you want to deploy \(eg Greeter\)?
read contract

forge create ./src/${contract}.sol:${contract} -i --rpc-url $rpc --constructor-args "0x04e01A000a44F6CAb464594E63b70E39B4C8a22a" "ipfs://QmRAakxqsTJqGAhd5yd3iip4fEL7KMZanTaxLH9k2wHqND" "NFTApp" "NFTA"
