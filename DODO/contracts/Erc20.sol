// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract _ERC20 is ERC20, Ownable {
    
    uint8 private currentDecimals;
    enum TOKEN_TYPE {CAPPED,UNCAPPED}
    TOKEN_TYPE public tokenType;
    
    constructor(
        string memory _name, 
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply,
        TOKEN_TYPE _tokenType
    ) ERC20(_name, _symbol) {
        currentDecimals = _decimals;
        tokenType = _tokenType;
        // mint token to the address of the account that sent the transaction.
        transferOwnership(tx.origin);
        _mint(tx.origin, _initialSupply * (10**uint256(_decimals)));
    }

    modifier unCapped {
      require(tokenType == _ERC20.TOKEN_TYPE.UNCAPPED,"support only uncapped token");
      _;
    }

    function decimals() public view virtual override returns (uint8) {
        return currentDecimals;
    }

    function mint(address _address,uint256 _amount) public unCapped onlyOwner returns (bool) {
        _mint(_address,_amount);
        return true;
    }

    function burn(address _address,uint256 _amount) public unCapped onlyOwner returns (bool) {
        _burn(_address,_amount);
        return true;
    }
}