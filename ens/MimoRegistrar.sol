pragma solidity ^0.4.18;

import "./ENS.sol";

/**
 * A registrar that allocates subdomains to the first person to claim them.
 */

contract MimoRegistrar is Ownable {
    ENS public ens;
    bytes32 public rootNode;

    // The Mimo Resolver interface
    ResolverInterface public resolver;

    modifier only_owner(bytes32 subnode) {
        address currentOwner = ens.owner(keccak256(rootNode, subnode));
        require(currentOwner == 0 || currentOwner == msg.sender);
        _;
    }

    /**
     * Constructor.
     * @param ensAddr The address of the ENS registry.
     * @param node The node that this registrar administers.
     */
    function MimoRegistrar(ENS ensAddr, bytes32 node, ResolverInterface _resolver) public {
        ens = ensAddr;
        rootNode = node;
        resolver = _resolver;
    }

    /**
     * Register a name, or change the owner of an existing registration.
     * @param subnode The hash of the label to register.
     * @param owner The address of the new owner.
     */
    function register(bytes32 _subnode, address _owner) public only_owner(_subnode) {
        ens.setSubnodeOwner(rootNode, _subnode, _owner);
    }

    function giveBackOwnership() public onlyOwner {
        ens.setOwner(rootNode, owner);
    }

    function subnodeOwner(bytes32 subnode) public view returns (address) {
        return ens.owner(keccak256(rootNode, subnode));
    }

    function nodeOwner(bytes32 _node) public view returns (address) {
        return ens.owner(_node);
    }

    function getNode(bytes32 _subnode) public pure returns (bytes32) {
        return keccak256(rootNode, _subnode);
    }
}
