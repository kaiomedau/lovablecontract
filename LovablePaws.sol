// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.8.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.8.0/utils/Counters.sol";

contract BooCupWhitelist is Ownable {
    mapping(address => uint256) _wlAddresses;

    modifier WhiteListed(address addr) {
        require(_wlAddresses[addr] > 0, "Address is Not in the Whitelist");
        _;
    }

    function addAddressesToList(address[] memory addresses, uint256 count)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < addresses.length; i++) {
            require(addresses[i] != address(0), "Can't add a null address.");

            _wlAddresses[addresses[i]] = count;
        }
    }

    function removeAddressesFromList(address[] memory addresses)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < addresses.length; i++) {
            require(addresses[i] != address(0), "Can't remove null address.");

            _wlAddresses[addresses[i]] = 0;
        }
    }

    function whitelistCount(address addr) public view returns (uint256) {
        return _wlAddresses[addr];
    }

    function substractListCount(address addr) internal {
        uint256 count = _wlAddresses[addr];
        require(count > 0, "Address has no more slots");

        _wlAddresses[addr] = count - 1;
    }
}

/*****/
// Lovable Paws
/*****/
contract LovablePaws is
    ERC721,
    ERC721Enumerable,
    ERC721Burnable,
    Ownable,
    BooCupWhitelist
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 private _price;
    bool public paused;

    constructor(uint256 price) ERC721("Lovable Paws", "LPaw") {
        _price = price;
        paused = true;
    }

    // Mint
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function mintWhitelist() public payable {
        //TODO
    }

    function mint() public payable {
        //TODO
    }

    // Pause
    function togglePaused() external onlyOwner {
        paused = !paused;
    }

    // Price
    function setTokenPrice(uint256 price) external onlyOwner {
        _price = price;
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
