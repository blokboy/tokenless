pragma solidity ^0.4.24;


contract Mimo is Ownable {

    // The Mimo Registrar interface
    RegistrarInterface public registrar;

    // The Mimo Resolver interface
    ResolverInterface public resolver;

    // The Mimo Storage interface
    StorageInterface public store;

    // current profile id
    uint256 public id;

    // price of a profile
    uint256 public price;

    modifier mustExist(uint256 _id) {
        require(registrar.subnodeOwner(store.getNode(_id)) != address(0));
        _;
    }

    modifier onlyAuthorized(uint256 _id) {
        require(msg.sender == registrar.subnodeOwner(store.getNode(_id)));
        _;
    }

    function Mimo(RegistrarInterface _registrar, ResolverInterface _resolver, StorageInterface _store, uint256 _price) public {
        registrar = _registrar;
        resolver = _resolver;
        store = _store;
        id = 1;
        price = _price;
    }

    function createProfile(string _handle) public payable {
        require(msg.value >= price);
        registrar.register(keccak256(_handle), msg.sender, _handle, id);
        bytes32 domain = registrar.getDomain(keccak256(_handle));
        store.setNode(id, domain);
        id++;
    }

    // Can be used to add any attribute to a Mimo profile
    // Here are some standards to adhere to however:
    // _key = 'userql' refers to a graphql endpoint that returns all the info on a Mimo profile
    // _key = 'followerql' refers to a graphql endpoint that returns all the info on a profile's followers
    function addAttribute(uint256 _id, string _key, string _value) public {
        bytes32 node = store.getNode(_id);
        resolver.setText(node, _key, _value);
    }

    function followProfile(uint256 _initiatorId, uint256 _targetId) public onlyAuthorized(_initiatorId) mustExist(_initiatorId) mustExist(_targetId) {
        store.follow(_initiatorId, _targetId);
    }

    function unfollowProfile(uint256 _initiatorId, uint256 _targetId) public onlyAuthorized(_initiatorId) mustExist(_initiatorId) mustExist(_targetId) {
        store.unfollow(_initiatorId, _targetId);
    }

    function giveBackOwnership() public onlyOwner {
        store.transferOwnership(owner);
    }

}
