<script>
    import {ethers} from 'ethers';
    export let contractAddr = '';
    export let contractAbi = {abi : null};
    export let web3Props = { 
        provider: null, 
        signer: null, 
        account: null, 
        chainId: null, 
        contract: null 
    };
    
    async function connectWallet() {
        let provider = new ethers.providers.Web3Provider(window.ethereum, 'any');
        
        await provider.send('eth_requestAccounts',[]);
        const signer = provider.getSigner();
        const account = await signer.getAddress();
        const chainId = await signer.getChainId();
        const contract = new ethers.Contract(contractAddr, contractAbi.abi, signer);
        web3Props = { provider, signer, account, chainId, contract };
    }
</script>

<div class="WalletAdd">
<button class="bttn" on:click={connectWallet}>Attach Wallet</button>
</div>
 
<style>
.WalletAdd {
    border-radius: 5px;
    padding: 20px;
    overflow: hidden;
    position: relative;
    background-color: rgb(179, 245, 200);
    box-shadow: 1px 4px 1px rgba(0,0,0,0.3);
}
.bttn {
        background-color: rgb(235, 192, 255);
        text-decoration: aqua;
    }
</style>