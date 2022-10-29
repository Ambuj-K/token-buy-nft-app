<script>
  import {ethers} from 'ethers';
  export let web3Props = { 
      provider: null, 
      signer: null, 
      account: null, 
      chainId: null, 
      contract: null 
  };

  $: NFT_json = null;
  $: image_url = null;
  $: status = null;

  async function Mint() {
      status = "MINTING...";
      await web3Props.contract.requestNft({
          value: 60000000,
          gasLimit: 100000
      });

      web3Props.contract.on("mintedNFT", async (uri_no,addr) =>  { 
         NFT_json = await web3Props.contract.artURIsGetter(uri_no);
         const response = await fetch("https://api.ipfsbrowser.com/ipfs/get.php?hash="+NFT_json.split("//")[1]);
         const data = await response.json();
         image_url = "https://api.ipfsbrowser.com/ipfs/get.php?hash="+String(data.image).split("//")[1];
         status = "LOADED";
      });
  }
</script>

<div class='wrapper'>
  {#if !NFT_json & status!="MINTING..."}
  <button class='bttn' on:click={Mint}>Mint An NFT</button>
  <br/>
  {:else if status=="MINTING..."}
  <div class="loading">
      {status}
  </div> 
  <br/>
  {:else}
  {#if image_url}
  <div class="loaded">
      {status}
  </div> 
  <br/>
      <img class="image_div" src={image_url} alt="Loading..."/>
  {/if}
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