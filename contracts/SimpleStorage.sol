pragma solidity ^0.4.11;

import "../installed_contracts/zeppelin/contracts/lifecycle/Pausable.sol";

contract SimpleStorage is Pausable {
  uint256 public a;
  bytes32 public b;

  function setA(uint256 _a) onlyOwner whenNotPaused public returns (bool) {
    a = _a;

    return true;
  }

  function setB(bytes32 _b) onlyOwner whenNotPaused public returns (bool) {
    b = _b;

    return true;
  }
}
