pragma solidity ^0.4.24;


contract Mimo {

    // The Mimo Registrar interface
    RegistrarInterface public registrar;

    // The Mimo Resolver interface
    ResolverInterface public resolver;

    // Price of a Mimo profile
    uint256 public price;

    // Tracks whether a profile is in use or not
    mapping (bytes32 => bool) public active;

    modifier mustExist(bytes32 _node) {
        require(active[_node] == true);
        _;
    }

    modifier onlyAuthorized(bytes32 _node) {
        require(msg.sender == registrar.nodeOwner(_node));
        _;
    }

    // Tracks who follows who, latest instance of an event with filters for
    // _following and _followed will return a _response
    // This will tell us if a profile follows another or not
    event Follow(bytes32 indexed _following, bytes32 indexed _followed, bool indexed _response);

    function Mimo(RegistrarInterface _registrar, ResolverInterface _resolver, uint256 _price) public {
        registrar = _registrar;
        resolver = _resolver;
        price = _price;
    }

    function createProfile(string _handle) public payable {
        require(msg.value >= price);
        registrar.register(keccak256(_handle), msg.sender);
        active[profileNode(_handle)] = true;
    }

    function setProfileOwner(string _handle, address _owner) public {
        require(profileOwner(_handle) != address(0));
        require(_owner != address(0));
        require(_owner != profileOwner(_handle));
        registrar.register(keccak256(_handle), _owner);
    }

    function deactivateProfile(bytes32 _node) public onlyAuthorized(_node) mustExist(_node) {
        active[_node] = false;
    }

    function reactivateProfile(bytes32 _node) public onlyAuthorized(_node) {
        active[_node] = true;
    }

    function setProfileAddress(bytes32 _node, address _addr) public onlyAuthorized(_node) mustExist(_node) {
        resolver.setAddr(_node, _addr);
    }

    function setInfo(bytes32 _node, string _key, string _value) public onlyAuthorized(_node) mustExist(_node) {
        resolver.setText(_node, _key, _value);
    }

    function followProfile(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) mustExist(_initiator) mustExist(_target) {
        emit Follow(_initiator, _target, true);
    }

    function unfollowProfile(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) mustExist(_initiator) mustExist(_target) {
        emit Follow(_initiator, _target, false);
    }

    function profileAddress(bytes32 _node) public view mustExist(_node) returns(address) {
        return resolver.addr(_node);
    }

    function profileOwner(string _handle) public view returns(address) {
        require(active[profileNode(_handle)] == true);
        return registrar.subnodeOwner(keccak256(_handle));
    }

    function profileNode(string _handle) public pure returns(bytes32) {
        return registrar.getNode(keccak256(_handle));
    }

}
