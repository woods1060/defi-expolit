# Working POC of Fei Protocol Vulnerability

This is little modified POC of Fei Protocol's vulnerability which is reported by [@lucash_dev](https://twitter.com/lucash_dev) through Immunefi.  
  
Tested on Windows environment.
```
1. npm install  
2. Modify "{YOUR_JSON-RPC_ENDPOIT}" in "hardhat.config.js", "poc.js" files. 
3. npx hardhat run .\scripts\poc.js  
```
![Execution image](https://github.com/illicitco/Working-POC-of-Fei-Protocol-Vulnerability/blob/main/image.png)

  
Further resources  
[Fei Protocol Flashloan Vulnerability Postmortem](https://medium.com/immunefi/fei-protocol-flashloan-vulnerability-postmortem-7c5dc001affb)  
[A Guide to Reproducing Ethereum Exploits: Fei Protocol](https://medium.com/immunefi/a-guide-to-reproducing-ethereum-exploits-fei-protocol-224b30b517d6)
