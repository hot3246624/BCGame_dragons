pragma solidity ^0.4.19;

import "./dargonAttack.sol";
import "./erc721.sol";
import "./safemath.sol";

/// @title a contract which transfer pets
/// @author Mr.Huang
/// @dev fit ERC721
contract DargonOwnership is dargonAttack, ERC721 {

  using SafeMath for uint256;

  mapping (uint => address) dargonApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerDargonCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return dargonToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerDargonCount[_to] = ownerDargonCount[_to].add(1);
    ownerDargonCount[msg.sender] = ownerDargonCount[msg.sender].sub(1);
    dargonToOwner[_tokenId] = _to;
    Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    dargonApprovals[_tokenId] = _to;
    Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(dargonApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
