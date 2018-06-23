pragma solidity ^0.4.18;


interface RegistrarInterface {

    function register(bytes32 subnode, address owner) public only_owner(subnode);

}
