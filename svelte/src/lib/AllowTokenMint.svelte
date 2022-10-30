<script>
    import {ethers} from 'ethers';
    export let web3Props = { 
          provider: null, 
          signer: null, 
          account: null, 
          chainId: null, 
          addressNFTApp: null, 
          contractNFTApp: null,
          contractCoinApp: null
    };
    $: inputField = null;
    $: amount = null;
    $: status = null;
    $: NFT_token_price = null;
    $: user_token_balance = null;
  
    async function Mint(art_uri) {
        await web3Props.contractNFTApp.mint(web3Props.account, art_uri, {
              gasLimit: 5000000
          });
        status = "MINTING...";
        web3Props.contractNFTApp.on("NFTApp__NFTMintToUserSuccess", async (addr,uri) =>  { 
          status = "LOADED";
        });
    }
  
    async function approveNFTContractToken(){
      // approve tokens to contract for users
      web3Props.contractCoinApp.approve(web3Props.addressNFTApp, ethers.utils.parseEther("1000000000000"));
    }
  
  //   approveNFTContractToken();
  
    async function transferTokensToUser(){
      // transfer tokens to users
      await web3Props.contractNFTApp.transferTokensToUser(web3Props.account, ethers.utils.parseEther(String(amount*100)), {
              gasLimit: 5000000
          });
      await userTokenBalance();
      console.log(user_token_balance);
      inputField.value='';
    }
  
    async function userTokenBalance(){
      // user token balance
      user_token_balance = await web3Props.contractNFTApp.getUserTokenBalance(web3Props.account)/1e18;
    }
    userTokenBalance();
  
    async function pricePerNFTToken(){
      // price per nft token
      NFT_token_price = await web3Props.contractNFTApp.getPerTokenValue();
    }
    pricePerNFTToken();
    
  </script>
  
  <div class='wrapper'>
    {#if status!="MINTING..."}
      Each NFT Price is {NFT_token_price} Tokens<br/>
      <input className="writeInput" placeholder="N no of nfts to be bought" type="text" autoFocus={true}
      bind:value={amount} size="25" height="20" bind:this={inputField}/><br/>
      You get N x {NFT_token_price} Tokens<br/><br/>
      <button class='bttn' on:click={transferTokensToUser}>Mint Tokens</button>
      <br/><br/>
      Your current token balance is {user_token_balance}<br/><br/><br/>
      {#if user_token_balance}
          <div class="row">
              <div class="column column-1">
                  <img class="image_div" src={"https://api.ipfsbrowser.com/ipfs/get.php?hash=QmW5hZbSWAVrc4EeUMsxVgQ8pdmSyKuheChi6HswsLQ95Y"} alt="Loading..."/>
                  <br/><br/>
                  <button class='bttn' on:click|preventDefault={()=>Mint("ipfs://Qmc6qfwny924kLWfoxKpA3VsauFKnBUecm8912RM1DfJbe")}>Mint This NFT</button>
              </div>
              <div class="column column-2">
                  <img class="image_div" src={"https://api.ipfsbrowser.com/ipfs/get.php?hash=QmT4Bo748YNMQtkrmsFimPYrpP4ni1yiVodUq9NfBxR8ei"} alt="Loading..."/>
                  <br/><br/>
                  <button class='bttn' on:click|preventDefault={()=>Mint("ipfs://QmYgb3tawCnMGPMV4DGFawNznEBzoFNXsZNwvTPDB4mZxc")}>Mint This NFT</button>
              </div>
          </div>
      <br/>
      {/if}
    {:else if status=="MINTING..."}
      <div class="loading">
          {status}
      </div> 
      <br/>
    {/if}
  </div>
  
  <style>
    .wrapper {
        border-radius: 5px;
        padding: 20px;
        overflow: hidden;
        position: relative;
        background-color: wheat;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
    .bttn{
        background-color: pink;
        text-decoration: aqua;
    }
    .image_div{
        background-color: wheat;
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
        width: 500px;
        height: 500px;
    }
    .loading{
        background-color: pink;
        text-decoration: aqua;
        width: 100px;
        height: 25px;
        overflow: hidden;
        position: relative;
        text-align: center;
        text-shadow: 0ex;
    }
    .loaded{
        background-color: pink;
        text-decoration: aqua;
        width: 100px;
        height: 25px;
        overflow: hidden;
        position: relative;
        text-align: center;
        text-shadow: 0ex;
    }
      .row {
      display: flex;
      }
  
      .column {
      flex: 50%;
      text-align: center;
      }
  </style>