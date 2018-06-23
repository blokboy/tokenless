pragma solidity ^0.4.19;


contract MimoStorage is Ownable {

    event Follow(bytes32 indexed _following, bytes32 indexed _followed, bool indexed _response);

    // ties Mimo handles to ENS subdomains
    mapping (string => bytes32) internal profiles;

    function follow(bytes32 _following, bytes32 _followed) public {
        emit Follow(_following, _followed, true);
    }

    function unfollow(bytes32 _unfollowing, bytes32 _unfollowed) public {
        emit Follow(_unfollowing, _unfollowed, false);
    }

    function setNode(string _handle, bytes32 _node) public {
        profiles[_handle] = _node;
    }

    function getNode(string _handle) public view returns (bytes32) {
        return profiles[_handle];
    }

}
