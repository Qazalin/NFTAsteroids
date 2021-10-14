// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

// Importing libraries
// ERC721URI STORAGE -> creating the nft and storing its uri
// Counters -> keeping track of tokenIds
// Ownable -> security
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Asteroids is ERC721URIStorage, Ownable {
    // Keeping track of tokenIds:
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;
    uint256 private price = 25000000000000000; // 0.025 Ether
    bool public isSaleActive = true;
    string baseURI;

    // Add events
    event NewNFTMinted(address sender, uint256 tokenId);

    // Setting up the constants
    constructor() ERC721("MyEpicNFT", "EPIC") {}

    // function for minting the nft
    function makeNFT(string memory _tokenURI) public payable {
        require(isSaleActive == true, "sales not active yet");
        require(msg.value >= price, "Ether value sent is not correct");
        // Get the current tokenId, starting from 0
        uint256 newItemId = _tokenIds.current();
        // mint nft to sender
        _safeMint(msg.sender, newItemId);

        // Set NFT data
        // the args are as follows: _setTokenURI(newItemId, _tokenURI);
        // for this contract though, each token uri has 111 more than the last one
        _setTokenURI(newItemId, _tokenURI);

        // Emit the event
        emit NewNFTMinted(msg.sender, newItemId);

        // Increment the counter for when the next NFT is minted
        _tokenIds.increment();

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
    }

    // view functions
    function getPrice() public view returns (uint256) {
        return price;
    }

    // onlyOwner functions
    // withdraw money from the contract
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    // activate/deactivate sales
    function flipSaleStatus() public onlyOwner {
        isSaleActive = !isSaleActive;
    }
}
