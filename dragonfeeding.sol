pragma solidity ^0.4.19;

import "./dragonfactory.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract DragonFeeding is DragonFactory {

  KittyInterface kittyContract;

  modifier onlyOwnerOf(uint _DragonId) {
    require(msg.sender == dragonToOwner[_DragonId]);
    _;
  }

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Dragon storage _dragon) internal {
    _dragon.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Dragon storage _dragon) internal view returns (bool) {
      return (_dragon.readyTime <= now);
  }

  function feedAndMultiply(uint _dragonId, uint _targetDna, string _species) internal onlyOwnerOf(_dragonId) {
    Dragon storage myDragon = dragons[_dragonId];
    require(_isReady(myDragon));
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myDragon.dna + _targetDna) / 2;
    if (keccak256(_species) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createDragon("NoName", newDna);
    _triggerCooldown(myDragon);
  }

  function feedOnKitty(uint _dragonId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_dragonId, kittyDna, "kitty");
  }
}
