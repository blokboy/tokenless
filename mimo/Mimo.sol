pragma solidity ^0.4.24;


contract Mimo is Ownable {

    // The Mimo Registrar interface
    RegistrarInterface public registrar;

    // The Mimo Resolver interface
    ResolverInterface public resolver;

    modifier onlyActive(bytes32 _node) {
        require(active(_node) == true);
        _;
    }

    modifier onlyAuthorized(bytes32 _node) {
        require(msg.sender == profileOwner(_node));
        _;
    }

    event Profile(bytes32 indexed _node, uint256 indexed _timestamp);

    function Mimo(RegistrarInterface _registrar, ResolverInterface _resolver) public {
        registrar = _registrar;
        resolver = _resolver;
    }

    function createProfile(bytes32 _subnode) public payable {
        require(msg.value >= price);
        require(active(profileNode(_subnode)) == false);
        require(profileOwner(_subnode) == address(0));
        registrar.register(_subnode, msg.sender);
        setProfileInfo(profileNode(_subnode), "mimo:active", keccak256("true"));
        emit Profile(profileNode(_subnode), block.timestamp);
    }

    function setProfileOwner(bytes32 _subnode, address _owner) public onlyAuthorized(profileNode(_subnode)) onlyActive(profileNode(_subnode)) {
        require(_owner != address(0));
        require(_owner != profileOwner(profileNode(_subnode));
        registrar.register(_subnode, _owner);
    }

    function deactivateProfile(bytes32 _node) public onlyAuthorized(_node) onlyActive(_node) {
        setProfileInfo(_node, "mimo:active", keccak256("false"));
    }

    function reactivateProfile(bytes32 _node) public onlyAuthorized(_node) {
        setProfileInfo(_node, "mimo:active", keccak256("true"));
    }

    // deleteProfile() also deletes all profile data stored off-chain
    function deleteProfile(bytes32 _node) public onlyAuthorized(_node) onlyActive(_node) {
        setProfileInfo(_node, "mimo:active", keccak256("false"));
    }

    function setProfileAddress(bytes32 _node, address _addr) public onlyAuthorized(_node) onlyActive(_node) {
        resolver.setAddr(_node, _addr);
    }

    function setProfileInfo(bytes32 _node, string _key, string _value) public onlyAuthorized(_node) onlyActive(_node) {
        resolver.setText(_node, _key, _value);
    }

    function setProfileContent(bytes32 _node, bytes32 _content) public onlyAuthorized(_node) onlyActive(_node) {
        resolver.setContent(_node, _content);
    }

    function setProfileMultihash(bytes32 _node, bytes _hash) public onlyAuthorized(_node) onlyActive(_node) {
        resolver.setMultihash(_node, _hash);
    }

    function follow(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) onlyActive(_initiator) onlyActive(_target) {}

    function unfollow(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) onlyActive(_initiator) onlyActive(_target) {}

    function metadata(bytes32 _node, string _key, string _value) public onlyAuthorized(_node) onlyActive(_node) {}

    function active(bytes32 _node) public view returns(bool) {
        return resolver.text(_node, "mimo:active") == keccak256("true");
    }

    function profileAddress(bytes32 _node) public view onlyActive(_node) returns(address) {
        return resolver.addr(_node);
    }

    function profileInfo(bytes32 _node, string _key) public view onlyActive(_node) returns(string) {
        return resolver.text(_node, _key);
    }

    function profileContent(bytes32 _node) public view onlyActive(_node) returns(bytes32) {
        return resolver.content(_node);
    }

    function profileMultihash(bytes32 _node) public view onlyActive(_node) returns(bytes) {
        return resolver.multihash(_node);
    }

    function profileOwner(bytes32 _node) public view onlyActive(_node) returns(address) {
        return registrar.nodeOwner(_node);
    }

    function profileNode(bytes32 _subnode) public pure returns(bytes32) {
        return registrar.getNode(_subnode);
    }

    function giveBackOwnership() public onlyOwner {
        resolver.transferOwnership(owner);
    }

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

}
