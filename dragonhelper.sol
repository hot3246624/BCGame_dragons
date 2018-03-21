pragma solidity ^0.4.19;

import "./dragonfeeding.sol";

contract DragonHelper is DragonFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _dragonId) {
    require(dragons[_dragonId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _dragonId) external payable {
    require(msg.value == levelUpFee);
    dragons[_dragonId].level++;
  }

  function changeName(uint _dragonId, string _newName) external aboveLevel(2, _dragonId) onlyOwnerOf(_dragonId) {
    dragons[_dragonId].name = _newName;
  }

  function changeDna(uint _dragonId, uint _newDna) external aboveLevel(20, _dragonId) onlyOwnerOf(_dragonId) {
    dragons[_dragonId].dna = _newDna;
  }

  function getdragonsByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerDragonCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < dragons.length; i++) {
      if (DragonToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}
