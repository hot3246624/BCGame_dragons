pragma solidity ^0.4.19;

import "./dragonhelper.sol";

contract DragonBattle is DragonHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce++;
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _dragonId, uint _dragontId) external onlyOwnerOf(_dragonId) {
    Dragon storage myDragon = dragon[_dragonId];
    Dragon storage enemyDragon = dragons[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      myDragon.winCount++;
      myDragon.level++;
      enemyDragon.lossCount++;
      feedAndMultiply(_dragonId, enemyDragon.dna, "dragon");
    } else {
      myDragon.lossCount++;
      enemyDragon.winCount++;
      _triggerCooldown(myDragon);
    }
  }
}
