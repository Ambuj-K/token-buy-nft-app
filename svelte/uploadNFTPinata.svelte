<script>
    $: image = ''
    $: hash = ''
    $: description = ''
    $: value = ''
    $: name = ''

    const json_uri_info = {
        "name": name,
        "description": description,
        "image": image,
        "attributes": [
        {
            "trait_type": "Artistic",
            "value": value
        }]
    }

    const pinJSONToIPFS = async (info, flag) => {
        const url = `https://api.pinata.cloud/pinning/pinJSONToIPFS`;
        var response_dict = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                pinata_secret_api_key:'',
                pinata_api_key: ''
            }
        };
        if (flag == "img")
        {
            response_dict[data]=info
        }
        else {
            response_dict[body]=JSON.stringify(info)
        }
        const response = await fetch(url, 
        response_dict
        );
        var res = await response.json()
        hash = res.IpfsHash
        console.log(hash)
    }

    const uploadFile = async(fileImgpath, _name, _description, _value) => {
        name = _name;
        description = _description;
        value = _value
        try {
                const formData = new FormData();
                formData.append("file", fileImgpath);
                hash = await pinJSONToIPFS(formData, "img");
                image = "ipfs://"+hash
                await pinJSONToIPFS(json_uri_info, "json");
                console.log("ipfs://"+hash)
            } 
        catch (error) {
                console.log("Error sending File to IPFS: ")
                console.log(error)
            }        
    }

    uploadFile("/usr/Downloads/Aeronaut.jpg","Astronaut","Astronaut, Stout",90)
    uploadFile("/usr/Downloads/Wings.jpg","Astronaut","Wings, Beautiful",80)
</script>