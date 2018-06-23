pragma solidity ^0.4.24;


contract Mimo is Ownable {

    // The Mimo Registrar interface
    RegistrarInterface public registrar;

    // The Mimo Resolver interface
    ResolverInterface public resolver;

    // The Mimo Storage interface
    StorageInterface public store;

    // price of a profile
    uint256 public price;

    modifier mustExist(bytes32 _node) {
        require(registrar.nodeOwner(_node) != address(0));
        _;
    }

    modifier onlyAuthorized(bytes32 _node) {
        require(msg.sender == registrar.nodeOwner(_node));
        _;
    }

    function Mimo(RegistrarInterface _registrar, ResolverInterface _resolver, StorageInterface _store, uint256 _price) public {
        registrar = _registrar;
        resolver = _resolver;
        store = _store;
        price = _price;
    }

    function createProfile(string _handle) public payable {
        require(msg.value >= price);
        registrar.register(keccak256(_handle), msg.sender);
        bytes32 domain = registrar.getDomain(keccak256(_handle));
        resolver.setAddr(domain, msg.sender);
        resolver.setName(domain, _name);
        store.setNode(_handle, domain);
        id++;
    }

    // Can be used to add any attribute to a Mimo profile
    // Here are some standards to adhere to however:
    // _key = 'userql' refers to a graphql endpoint that returns all the info on a Mimo profile
    // _key = 'followerql' refers to a graphql endpoint that returns all the info on a profile's followers
    function addAttribute(bytes32 _node, string _key, string _value) public {
        resolver.setText(_node, _key, _value);
    }

    function followProfile(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) mustExist(_initiator) mustExist(_target) {
        store.follow(_initiator, _target);
    }

    function unfollowProfile(bytes32 _initiator, bytes32 _target) public onlyAuthorized(_initiator) mustExist(_initiator) mustExist(_target) {
        store.unfollow(_initiator, _target);
    }

    function giveBackOwnership() public onlyOwner {
        store.transferOwnership(owner);
    }

    function changePrice(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    // Withdraw the funds of the account from fees received by charging for profiles
    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

}
