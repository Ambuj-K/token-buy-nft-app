<script>

    import { Network, Alchemy } from "alchemy-sdk";

    export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null, 
        contract: null 
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
            if (response.rawMetadata.description == "Astronaut, Stout"){
                const NFT_response = await fetch("https://api.ipfsbrowser.com/ipfs/get.php?hash="+response.rawMetadata.external_url.split("//")[1]);
                const data = await NFT_response.json();
                NFTs = [...NFTs, [data["title"], data["text"]]];
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
                <p>{NFT[1]}</p>
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
	
</style>