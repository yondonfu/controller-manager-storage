pragma solidity ^0.4.11;

import "./Controllable.sol";

import "../installed_contracts/zeppelin/contracts/lifecycle/Pausable.sol";

contract Controller is Pausable {
  // Track registered child contracts
  mapping (bytes32 => address) registry;

  function getRegistryContract(string _name) whenNotPaused public constant returns (address) {
    return registry[keccak256(_name)];
  }

  function setRegistryContract(string _name, address _contract) onlyOwner whenNotPaused public returns (bool) {
    registry[keccak256(_name)] = _contract;

    return true;
  }

  function updateController(string _name, address _controller) onlyOwner whenPaused public returns (bool) {
    return Controllable(registry[keccak256(_name)]).setController(_controller);
  }
}
