pragma solidity ^0.4.24;


contract Mimo is Ownable {

    // The Mimo Registrar interface
    RegistrarInterface public registrar;

    // The Mimo Resolver interface
    ResolverInterface public resolver;

    // Price of a Mimo profile
    uint256 public price;

    // Tracks whether a profile is in use or not
    mapping (bytes32 => bool) public active;

    modifier onlyActive(bytes32 _node) {
        require(active[_node] == true);
        _;
    }

    modifier onlyAuthorized(bytes32 _node) {
        require(msg.sender == registrar.nodeOwner(_node));
        _;
    }

    event Profile(string indexed _handle, bytes32 indexed _node, uint256 indexed _timestamp);

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
        require(active[profileNode(_handle)] == false);
        require(profileOwner(_handle) == address(0));
        registrar.register(keccak256(_handle), msg.sender);
        active[profileNode(_handle)] = true;
        emit Profile(_handle, profileNode(_handle), block.timestamp);
    }

    function setProfileOwner(string _handle, address _owner) public {
        require(profileOwner(_handle) != address(0));
        require(msg.sender == profileOwner(_handle));
        require(active[profileNode(_handle)] == true);
        require(_owner != address(0));
        require(_owner != profileOwner(_handle));
        registrar.register(keccak256(_handle), _owner);
    }

    function deactivateProfile(bytes32 _node) public onlyAuthorized(_node) onlyActive(_node) {
        active[_node] = false;
    }

    function reactivateProfile(bytes32 _node) public onlyAuthorized(_node) {
        active[_node] = true;
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

    function followProfile(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) onlyActive(_initiator) onlyActive(_target) {
        emit Follow(_initiator, _target, true);
    }

    function unfollowProfile(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) onlyActive(_initiator) onlyActive(_target) {
        emit Follow(_initiator, _target, false);
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

    function profileOwner(string _handle) public view returns(address) {
        require(active[profileNode(_handle)] == true);
        return registrar.subnodeOwner(keccak256(_handle));
    }

    function profileNode(string _handle) public pure returns(bytes32) {
        return registrar.getNode(keccak256(_handle));
    }

    function giveBackOwnership() public onlyOwner {
        resolver.transferOwnership(owner);
    }

}
