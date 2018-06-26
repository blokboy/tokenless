pragma solidity ^0.4.24;


interface MimoInterface {

    function createProfile(string _handle) public payable;
    function setProfileOwner(string _handle, address _owner) public;
    function deactivateProfile(bytes32 _node) public onlyAuthorized(_node) onlyActive(_node);
    function reactivateProfile(bytes32 _node) public onlyAuthorized(_node);
    function setProfileAddress(bytes32 _node, address _addr) public onlyAuthorized(_node) onlyActive(_node);
    function setProfileInfo(bytes32 _node, string _key, string _value) public onlyAuthorized(_node) onlyActive(_node);
    function setProfileContent(bytes32 _node, bytes32 _content) public onlyAuthorized(_node) onlyActive(_node);
    function setProfileMultihash(bytes32 _node, bytes _hash) public onlyAuthorized(_node) onlyActive(_node);
    function follow(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) onlyActive(_initiator) onlyActive(_target);
    function unfollow(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) onlyActive(_initiator) onlyActive(_target);
    function registrar() public view returns(address);
    function resolver() public view returns(address);
    function price() public view returns(uint256);
    function active(bytes32 _bytes) public view returns(bool);
    function profileAddress(bytes32 _node) public view onlyActive(_node) returns(address);
    function profileInfo(bytes32 _node, string _key) public view onlyActive(_node) returns(string);
    function profileContent(bytes32 _node) public view onlyActive(_node) returns(bytes32);
    function profileMultihash(bytes32 _node) public view onlyActive(_node) returns(bytes);
    function profileOwner(string _handle) public view returns(address);
    function profileNode(string _handle) public pure returns(bytes32);

}
