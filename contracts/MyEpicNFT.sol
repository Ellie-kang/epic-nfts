// SPDX-License-Identifier: UNLICENSED

// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "hardhat/console.sol";

// // We need to import the helper functions from the contract that we copy/pasted.
// import { Base64 } from "./libraries/Base64.sol";

// contract MyEpicNFT is ERC721URIStorage {
//   using Counters for Counters.Counter;
//   Counters.Counter private _tokenIds;

//   string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

//   string[] firstWords = ["happy", "sad", "glad", "delighted", "pleasant", "fluttered"];

//   string[] secondWords = ["apple", "blueberry", "grapefruit", "lime", "mango", "peach"];

//   string[] thirdWords = ["life", "earth", "price", "route", "art", "effort"];

//   constructor() ERC721 ("SquareNFT", "SQUARE") {
//     console.log("This is my NFT contract. Woah!");
//   }

//   function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
//     uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
//     rand = rand % firstWords.length;
//     return firstWords[rand];
//   }

//   function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
//     uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
//     rand = rand % secondWords.length;
//     return secondWords[rand];
//   }

//   function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
//     uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
//     rand = rand % thirdWords.length;
//     return thirdWords[rand];
//   }

//   function random(string memory input) internal pure returns (uint256) {
//       return uint256(keccak256(abi.encodePacked(input)));
//   }

//   function makeAnEpicNFT() public {
//     uint256 newItemId = _tokenIds.current();

//     string memory first = pickRandomFirstWord(newItemId);
//     string memory second = pickRandomSecondWord(newItemId);
//     string memory third = pickRandomThirdWord(newItemId);
//     string memory combinedWord = string(abi.encodePacked(first, second, third));

//     string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

//     // Get all the JSON metadata in place and base64 encode it.
//     string memory json = Base64.encode(
//         bytes(
//             string(
//                 abi.encodePacked(
//                     '{"name": "',
//                     // We set the title of our NFT as the generated word.
//                     combinedWord,
//                     '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
//                     // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
//                     Base64.encode(bytes(finalSvg)),
//                     '"}'
//                 )
//             )
//         )
//     );

//     // Just like before, we prepend data:application/json;base64, to our data.
//     // JSON 메타데이터를 base64로 인코딩한 것 - on-chain (모든 JSON은 계약 자체에서 유지됨)
//     string memory finalTokenUri = string(
//         abi.encodePacked("data:application/json;base64,", json)
//     );

//     console.log("\n--------------------");
//     console.log(finalTokenUri);
//     console.log("--------------------\n");

//     _safeMint(msg.sender, newItemId);
    
//     // Update your URI!!!
//     _setTokenURI(newItemId, finalTokenUri);
  
//     _tokenIds.increment();
//     console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
//   }
// }


pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFTbkp is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint nftsQuantityAllowed = 50;
    string[] firstWords = ["happy", "sad", "glad", "delighted", "pleasant", "fluttered"];
    string[] secondWords = ["apple", "blueberry", "grapefruit", "lime", "mango", "peach"];
    string[] thirdWords = ["life", "earth", "price", "route", "art", "effort"];
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("I'm excited to get my NFT contract working!");
    }

    function concatRandomWords() public view returns (string memory, uint) {
        uint firstWordNr = uint(keccak256(abi.encodePacked(firstWords[0], Strings.toString(_tokenIds.current()), block.timestamp))) % firstWords.length - 1; 
        uint secondWordNr = uint(keccak256(abi.encodePacked(secondWords[0], Strings.toString(_tokenIds.current()), block.timestamp))) % secondWords.length - 1; 
        uint thirdWordNr = uint(keccak256(abi.encodePacked(thirdWords[0], Strings.toString(_tokenIds.current()), block.timestamp))) % thirdWords.length - 1;
        uint colorNumber = uint(keccak256(abi.encodePacked(firstWords[0], secondWords[0], thirdWords[0], block.timestamp))) % 1000000;
        console.log("Word numbers: %d %d %d", firstWordNr, secondWordNr, thirdWordNr); 
        console.log("Color number: ", colorNumber);
        string memory concatWords = string.concat(firstWords[firstWordNr], secondWords[secondWordNr], thirdWords[thirdWordNr]);
        console.log("Concatenated string is: %s", concatWords);
        // console.log("First Length: %s \n Second: %s \n Third: %s", firstWords.length, secondWords.length, thirdWords.length);
        return (concatWords, colorNumber);
    }

    function createImageString(string memory _randomWords, uint _colorNumber) public view returns (string memory) {
        string memory svg = string.concat("<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='#", Strings.toString(_colorNumber),"' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>", _randomWords,"</text></svg>");
        console.log("svg: %s", svg);
        string memory encodedSvg = Base64.encode(bytes(string(abi.encodePacked(svg))));
        // console.log ("encodedSvg: ", encodedSvg);
        string memory imageString = string.concat("data:application/json;base64,",encodedSvg);
        // console.log("imageString: ", imageString);
        return imageString;
    }

    function prepareEncodedJSON(string memory _randomWords, string memory _imageString) public pure returns (string memory) {
        string memory json = string.concat('{"name": "', _randomWords, '", "description" : "Funny collection of squares.", "image" : "', _imageString, '"}');
        // console.log("JSON: %s", json);
        string memory encodedJSON = Base64.encode(bytes(string(abi.encodePacked(json))));
        // console.log("encodedJSON: %s", encodedJSON);
        string memory jsonString = string.concat("data:application/json;base64,",encodedJSON);
        // console.log("jsonString: %s", jsonString);
        return jsonString;
    }

    function getTotalNFTsMintedSoFar() public view returns (uint) {
        uint totalNfts = _tokenIds.current();
        return totalNfts;
    }

    function makeAnEpicNFT() public {
        require(getTotalNFTsMintedSoFar() < nftsQuantityAllowed, "Just 50 NFTs can be minted on this contract");
        uint256 newItemId = _tokenIds.current();
        (string memory randomWords, uint randomColor) = concatRandomWords();
        string memory imageString = createImageString(randomWords, randomColor);
        string memory encodedJSON = prepareEncodedJSON(randomWords, imageString); 
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, encodedJSON);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function makeRandomNFTFromIPFS(string memory _ipfsLink) public {
        require(getTotalNFTsMintedSoFar() < nftsQuantityAllowed, "Just 50 NFTs can be minted on this contract");
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _ipfsLink);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }


}