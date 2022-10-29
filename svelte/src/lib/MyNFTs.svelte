<script>

    import { Network, Alchemy } from "alchemy-sdk";

    export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null,
        addressNFTApp: null,  
        contractNFTApp: null,
        contractCoinApp: null
    };

    $: NFTs = []
    let counter = 0;
    //get NFTS
    const settings = {
    apiKey: "",
    network: Network.ETH_GOERLI,
    };

    const alchemy = new Alchemy(settings);

    async function get_minted_nfts(){
        const ownerAddr = web3Props.account;
        const nftsForOwner = await alchemy.nft.getNftsForOwner(ownerAddr);

        for (const nft of nftsForOwner.ownedNfts) {
            const response = await alchemy.nft.getNftMetadata(
            nft.contract.address, nft.tokenId);
            if (response.rawMetadata.description == "Astronaut, Stout" || response.rawMetadata.description == "Wings, Beautiful"){
                const NFT_image = "https://api.ipfsbrowser.com/ipfs/get.php?hash="+response.rawMetadata.image.split("//")[1];
                NFTs = [...NFTs, [response.rawMetadata.name, NFT_image]];
                // console.log(response.rawMetadata)
            }
        }
    }
    get_minted_nfts()
</script>

<br/>
<br/>
{#if NFTs.length!=0}
    <b>Your NFTs</b>    
    <div>
        {#each NFTs as NFT}
            <div class="accordion">
                <label for="accordion-check-1">{NFT[0]}</label>
                <input type="checkbox" checked name="accordion2" id="accordion-check-1" hidden>
                <div class="accordion-item">
                <p><img class="image_div" src={NFT[1]} alt="Loading..."/></p>
            </div>
            </div>
        {/each} 
    </div>
{/if}
<!-- <button class='bttn' on:click={get_NFT_nfts}>Log NFTs</button> -->
<style>
@import url("https://fonts.googleapis.com/css2?family=Quicksand:wght@400;700&display=swap");
.accordion {
  background-color: white;
  color: black;
  border-radius: 0.5rem;
  overflow: hidden;
  width: 100%;
  display: flex;
  flex-direction: column;
}
.accordion > label {
  padding: 0.75rem 1rem;
  border-bottom: 1px solid whitesmoke;
  cursor: pointer;
  font-weight: bold;
}
.accordion > label:hover, .accordion > label:focus {
  background-color: whitesmoke;
}
.accordion .accordion-item {
  max-height: 0px;
  overflow: hidden;
  box-shadow: 0 -1px 0 0 whitesmoke inset;
  padding: 0 1rem;
}
.accordion input:checked + .accordion-item {
  max-height: 100vh;
  padding: 1.5rem 1rem;
}
.accordion.animate .accordion-item {
  transition: 0.25s ease;
}

* {
  box-sizing: border-box;
}

.image_div{
      background-color: wheat;
      box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
      width: 500px;
      height: 500px;
  }
	
</style>