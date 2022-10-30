<script>
    import WalletConnect from "../lib/WalletConnect.svelte";
    import AllowTokenMint from "../lib/AllowTokenMint.svelte"
    import MyNFTs from "../lib/MyNFTs.svelte"
    import contractNFTAppAbi from "../contracts/NFTApp.json";
    const contractNFTAppAddr =  "0xC2837AF74F17597d7c3328Ac6aA9A2dd6225399E";
    import contractAppTokenAbi from "../contracts/PlatformToken.json";
    const contractAppTokenAddr =  "0x04e01A000a44F6CAb464594E63b70E39B4C8a22a";
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