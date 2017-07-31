pragma solidity ^0.4.11;

import "../installed_contracts/zeppelin/contracts/lifecycle/Pausable.sol";

contract Controllable is Pausable {
  address public controller;

  modifier onlyController() {
    if (msg.sender != controller) throw;
    _;
  }

  function Controllable(address _controller) {
    controller = _controller;
  }

  function setController(address _controller) onlyController whenPaused public returns (bool) {
    controller = _controller;

    return true;
  }
}
