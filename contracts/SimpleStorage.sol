// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage {

    uint256 public favouriteNumber;
    mapping(string => uint256) public nameToFavouriteNumber;
     
    // To store data of single person
    // People public person = People({favouriteNumber: 2,name: "Gathin"});  (or)
    // People public person = People(2,"Gathin");

    struct People {
        uint256 favouriteNumber;
        string name;
    }
    //Storing in an array
    People[] public people;

    function store(uint256 _favouriteNumber) public virtual {
        favouriteNumber = _favouriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }
    //calldata,memory - temporary variables that can be changed   
    // storage - permanent variable that cant be changed

    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        // People memory newPerson = People(_favouriteNumber,_name); (or)
        people.push(People(_favouriteNumber,_name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}
