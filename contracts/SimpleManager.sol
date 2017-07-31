pragma solidity ^0.4.11;

import "./Controllable.sol";
import "./SimpleStorage.sol";

import "../installed_contracts/zeppelin/contracts/math/SafeMath.sol";

contract SimpleManager is Controllable {
  using SafeMath for uint256;

  SimpleStorage public simpleStorage;

  function SimpleManager(address _storageContract, address _controller) Controllable(_controller) {
    simpleStorage = SimpleStorage(_storageContract);
  }

  function add(uint256 _x) whenNotPaused public returns (bool) {
    return simpleStorage.setA(simpleStorage.a().add(_x));
  }

  function hash(string _x) whenNotPaused public returns (bool) {
    return simpleStorage.setB(keccak256(_x));
  }

  function setStorage(address _storageContract) onlyOwner whenPaused public returns (bool) {
    simpleStorage = SimpleStorage(_storageContract);

    return true;
  }

  function setStorageManager(address _manager) onlyOwner whenPaused public returns (bool) {
    simpleStorage.transferOwnership(_manager);

    return true;
  }
}
