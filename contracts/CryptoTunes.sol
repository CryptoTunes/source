pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';

contract CryptoTunes is Pausable {
  struct Tune {
    uint t1;
    uint t2;
    uint t3;
    uint t4;
    uint t5;
    uint t6;
    uint t7;
    uint t8;
  }

  mapping(address => uint[]) myFavorites;
  mapping(uint => uint) favoriteCount;
  uint favoriteFee = 0.001 ether;
  mapping(uint => address) tuneOwner;
  mapping(address => uint) artistTuneCount;
  Tune[] tunes;

  function CryptoTunes() public {
    owner = msg.sender;
    uint _t1 = uint(keccak256("Genesis Tune Track 1"));
    uint _t2 = uint(keccak256("Genesis Tune Track 2"));
    uint _t3 = uint(keccak256("Genesis Tune Track 3"));
    uint _t4 = uint(keccak256("Genesis Tune Track 4"));
    uint _t5 = uint(keccak256("Genesis Tune Track 5"));
    uint _t6 = uint(keccak256("Genesis Tune Track 6"));
    uint _t7 = uint(keccak256("Genesis Tune Track 7"));
    uint _t8 = uint(keccak256("Genesis Tune Track 8"));

    uint tuneId = tunes.push(Tune(_t1, _t2, _t3, _t4, _t5, _t6, _t7, _t8)) - 1;
    tuneOwner[tuneId] = msg.sender;
    artistTuneCount[msg.sender]++;
  }

  function getTune(uint _id) public view returns(
    uint, uint, uint, uint,
    uint, uint, uint, uint,
    address, uint) {
    Tune storage tune = tunes[_id];
    require(tune.t1 != 0);
    address thisTuneOwner = tuneOwner[_id];
    uint favCount = favoriteCount[_id];
    return (tune.t1, tune.t2, tune.t3, tune.t4,
    tune.t5, tune.t6, tune.t7, tune.t8,
    thisTuneOwner, favCount);
  }

  function getTunesLength() public view returns (uint) {
    return tunes.length;
  }

  function publishTune(uint _t1, uint _t2, uint _t3, uint _t4,
    uint _t5, uint _t6, uint _t7, uint _t8) whenNotPaused external payable returns (uint) {
    require(_t1 != 0);
    uint tuneId = tunes.push(Tune(_t1, _t2, _t3, _t4, _t5, _t6, _t7, _t8)) - 1;
    tuneOwner[tuneId] = msg.sender;
    artistTuneCount[msg.sender]++;
    return tuneId;
  }

  function getArtistTunes(address _artist) public view returns(uint[]) {
    uint[] memory theseTunes = new uint[](artistTuneCount[_artist]);
    uint inc = 0;
    for (uint i = 0; i < tunes.length; i++) {
      if (tuneOwner[i] == _artist) {
        theseTunes[inc] = i;
        inc++;
      }
    }
    return theseTunes;
  }

  function getMyFavorites() public view returns(uint[]) {
    return myFavorites[msg.sender];
  }

  function favorite(uint _id) whenNotPaused external payable {
    Tune storage tune = tunes[_id];
    require(tune.t1 != 0);
    require(msg.value >= favoriteFee);
    for (uint i = 0; i < myFavorites[msg.sender].length; i++) {
      require(_id != myFavorites[msg.sender][i]);
    }
    favoriteCount[_id]++;
    tuneOwner[_id].transfer(msg.value);
    myFavorites[msg.sender].push(_id);
  }

  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  function setFavoriteFee(uint _fee) external onlyOwner {
    favoriteFee = _fee;
  }
}
