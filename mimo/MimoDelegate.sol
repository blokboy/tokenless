pragma solidity ^0.4.24;

// A super simple example of a Mimo Delegate contract
// Does not take into account different authorization levels and whatnot

contract MimoDelegate is Ownable {

    /// ESSENTIAL BOILERPLATE CODE FOR DELEGATE CONTRACTS ///

    // Tracks whether an address can commit actions for your profile on your behalf
    mapping (address => bool) internal delegates;

    function addDelegate(address _addr) public onlyOwner {
        delegates[_addr] = true;
    }

    function removeDelegate(address _addr) public onlyOwner {
        delete delegates[_addr];
    }

    function isDelegate(address _addr) public view returns(bool) {
        return delegates[_addr];
    }

    /// OPTIONAL DELEGATE CODE ///
    // Below you may add whatever functions you want to your delegate contract
    // You can customize your contract to be able to access whatever Mimo functions you want
    // This contract could have access to all Mimo contract functions or only the following/unfollowing functions

}
