<script>
    import WalletConnect from "../lib/WalletConnect.svelte";
    import AllowTokenMint from "../lib/AllowTokenMint.svelte"
    import MyNFTs from "../lib/MyNFTs.svelte"
    import contractAbi from "../contracts/Medium.json";
    const contractAddr =  "0x007858d81f652DE257C81ca21B176E60B69d5f4b";
    export let web3Props = {
        provider : null,
        signer : null,
        account : null,
        chainId : null
    };
</script>

<div class="OUTER">
<h1>Mint Tokens Buy NFTs</h1>
</div>
{#if !web3Props.account}
<WalletConnect bind:web3Props {contractAddr} {contractAbi} />
{:else}
<br/>
<AllowTokenMint bind:web3Props />
<MyNFTs bind:web3Props />
{/if}

<style>
    .OUTER {
        border-radius: 15px;
        padding: 20px;
        overflow: hidden;
        position: relative;
        background-color: rgb(231, 146, 20);
        box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
    }
</style>