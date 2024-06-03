// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusicStreaming {
    struct Track {
        address artist;
        string ipfsHash;
        uint256 price;
    }

    uint256 public trackCount;
    mapping(uint256 => Track) public tracks;
    mapping(uint256 => mapping(address => bool)) public trackOwnerships;

    event TrackUploaded(uint256 trackId, address artist, string ipfsHash, uint256 price);
    event TrackPurchased(uint256 trackId, address buyer);

    function uploadTrack(string memory ipfsHash, uint256 price) external {
        trackCount++;
        tracks[trackCount] = Track(msg.sender, ipfsHash, price);
        emit TrackUploaded(trackCount, msg.sender, ipfsHash, price);
    }

    function purchaseTrack(uint256 trackId) external payable {
        Track storage track = tracks[trackId];
        require(msg.value == track.price, "Incorrect payment amount");
        require(!trackOwnerships[trackId][msg.sender], "Track already purchased");

        trackOwnerships[trackId][msg.sender] = true;
        payable(track.artist).transfer(msg.value);
        emit TrackPurchased(trackId, msg.sender);
    }

    function getTrack(uint256 trackId) external view returns (address artist, string memory ipfsHash, uint256 price, bool owned) {
        Track storage track = tracks[trackId];
        return (track.artist, track.ipfsHash, track.price, trackOwnerships[trackId][msg.sender]);
    }
}
