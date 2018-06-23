pragma solidity ^0.4.18;


interface ResolverInterface {

    function setAddr(bytes32 node, address addr) public only_owner(node);
    function setContent(bytes32 node, bytes32 hash) public only_owner(node);
    function setMultihash(bytes32 node, bytes hash) public only_owner(node);
    function setName(bytes32 node, string name) public only_owner(node);
    function setText(bytes32 node, string key, string value) public only_owner(node);
    function setMimoId(bytes32 node, uint256 id) public only_owner(node);
    function text(bytes32 node, string key) public view returns (string);
    function name(bytes32 node) public view returns (string);
    function content(bytes32 node) public view returns (bytes32);
    function multihash(bytes32 node) public view returns (bytes);
    function addr(bytes32 node) public view returns (address);
    function mimoId(bytes32 node) public view returns (uint256);
    function supportsInterface(bytes4 interfaceID) public pure returns (bool);
}
