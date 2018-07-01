pragma solidity ^0.4.24;

// A super simple example of a Mimo Delegate contract
// Does not take into account different authorization levels and whatnot

contract MimoDelegate is Ownable {

    /// ESSENTIAL BOILERPLATE CODE FOR DELEGATE CONTRACTS ///

    // Tracks whether an address can commit actions for your profile on your behalf
    mapping (address => bool) internal delegates;

    // Addresses that can read a profile's info
    mapping (address => bool) internal readers;

    modifier onlyDelegate() {
        require(isDelegate(msg.sender));
        _;
    }

    modifier onlyReader() {
        require(isReader(msg.sender));
        _;
    }

    function MimoDelegate(bytes32 _node) public {
        rootNode = _node;
    }

    function addDelegate(address _addr) public onlyOwner {
        delegates[_addr] = true;
    }

    function removeDelegate(address _addr) public onlyOwner {
        delete delegates[_addr];
    }

    function isDelegate(address _addr) public view returns(bool) {
        return delegates[_addr];
    }

    function addReader(address _addr) public onlyOwner {
        readers[_addr] = true;
    }

    function removeReader(address _addr) public onlyOwner {
        delete readers[_addr];
    }

    function isReader(address _addr) public view returns(bool) {
        return readers[_addr];
    }

    /// OPTIONAL DELEGATE CODE ///
    // Below you may add whatever functions you want to your delegate contract
    // You can customize your contract to be able to access whatever Mimo functions you want
    // This contract could have access to all Mimo contract functions or only the following/unfollowing functions

}
