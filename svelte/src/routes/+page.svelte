<script>
    import WalletConnect from "../lib/WalletConnect.svelte";
    import AllowTokenMint from "../lib/AllowTokenMint.svelte"
    import MyNFTs from "../lib/MyNFTs.svelte"
    import contractNFTAppAbi from "../contracts/NFTApp.json";
    const contractNFTAppAddr =  "0x3400f217877dC39ED534a750f3315196a8A58BfE";
    import contractAppTokenAbi from "../contracts/PlatformToken.json";
    const contractAppTokenAddr =  "0xc252C56BEFcDEb7fdE6ff42c31e7AE64FfddAb08";
    export let web3Props = {
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null,
        addressNFTApp: null, 
        contractNFTApp: null,
        contractCoinApp: null
    };
</script>

<div class="OUTER">
<h1>Mint Tokens Buy NFTs</h1>
</div>
{#if !web3Props.account}
<WalletConnect bind:web3Props {contractNFTAppAddr} {contractNFTAppAbi} {contractAppTokenAbi} {contractAppTokenAddr}/>
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