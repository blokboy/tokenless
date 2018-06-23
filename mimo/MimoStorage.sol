pragma solidity ^0.4.19;


contract MimoStorage is Ownable {
  
    event Follow(uint256 indexed _followingId, uint256 indexed _followedId, bool indexed _response);

    // ties Mimo IDs to ENS subdomains
    mapping (uint256 => bytes32) public profiles;

    function follow(uint256 _followingId, uint256 _followedId) public onlyOwner {
        emit Follow(_followingId, _followedId, true);
    }

    function unfollow(uint256 _followingId, uint256 _followedId) public onlyOwner {
        emit Follow(_followingId, _followedId, false);
    }

    function setNode(uint256 _id, bytes _node) public onlyOwner {
        profiles[_id] = _node;
    }

    function getNode(uint256 _id) public view returns (bytes32) {
        return profiles[_id];
    }

}
