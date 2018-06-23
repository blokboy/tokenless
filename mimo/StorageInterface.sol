pragma solidity ^0.4.19;


interface StorageInterface {

    function follow(uint256 _followingId, uint256 _followedId) public onlyOwner;
    function unfollow(uint256 _followingId, uint256 _followedId) public onlyOwner;
    function setNode(uint256 _id, bytes _node) public onlyOwner;
    function getNode(uint256 _id) public view returns (bytes32);
    
}
