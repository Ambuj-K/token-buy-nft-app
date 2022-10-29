<script>
  import {ethers} from 'ethers';
  export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null, 
        contractNFTApp: null,
        contractCoinApp: null
  };

  $: NFT_json = null;
  $: amount = null;
  $: status = null;
  $: NFT_token_price = null;
  $: user_token_balance = null;

  async function Mint(art_uri) {
      status = "MINTING...";
      await web3Props.contract.mint(art_uri,{
          value: 60000000,
          gasLimit: 100000
      });

      web3Props.contract.on("NFTApp__NFTMintToUserSuccess", async (uri_no,addr) =>  { 
         
         status = "LOADED";
      });
  }

  async function ApproveNFTContractToken(){
    // approve tokens to contract for users
  }
  ApproveNFTContractToken()

  async function transferTokensToUser(){
    // transfer tokens to users
  }

  async function userTokenBalance(){
    // user token balance
    user_token_balance = await web3Props.contractNFTApp.getUserTokenBalance(web3Props.account)/1e18;
  }
  userTokenBalance();

  async function pricePerNFTToken(){
    // price per nft token
    NFT_token_price = await web3Props.contractNFTApp.NFT_TOKEN_RATE;
    console.log(NFT_token_price)
  }
  pricePerNFTToken();
  
</script>

<div class='wrapper'>
  {#if !NFT_json & status!="MINTING..."}
    Each Token Price is {NFT_token_price}<br/>
    <input className="writeInput" placeholder="x 100" type="text" autoFocus={true}
    bind:value={amount} size="20" height="20"/>
    <button class='bttn' on:click={transferTokensToUser}>Mint Tokens</button>
    {user_token_balance}
    <button class='bttn' on:click={userTokenBalance}>check balance</button>
    <br/>
    Your current token balance is {user_token_balance}<br/><br/><br/>
    {#if user_token_balance}
        <img class="image_div" src={"https://api.ipfsbrowser.com/ipfs/get.php?hash=QmW5hZbSWAVrc4EeUMsxVgQ8pdmSyKuheChi6HswsLQ95Y"} alt="Loading..."/>
        <br/>
        <button class='bttn' on:click|preventDefault={()=>Mint("ipfs://Qmc6qfwny924kLWfoxKpA3VsauFKnBUecm8912RM1DfJbe")}>Mint This NFT</button>
        <br/>
        <br/>
        <img class="image_div" src={"https://api.ipfsbrowser.com/ipfs/get.php?hash=QmT4Bo748YNMQtkrmsFimPYrpP4ni1yiVodUq9NfBxR8ei"} alt="Loading..."/>
        <br/>
        <button class='bttn' on:click|preventDefault={()=>Mint("ipfs://QmYgb3tawCnMGPMV4DGFawNznEBzoFNXsZNwvTPDB4mZxc")}>Mint This NFT</button>
    <br/>
    {/if}
  {:else if status=="MINTING..."}
    <div class="loading">
        {status}
    </div> 
    <br/>
  {:else}
    <div class="loaded">
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
</style>