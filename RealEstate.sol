//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzepplin-contracts/blob/master/contracts/utils/math/safeMath.sol";

//Real estate contract for buying and selling properties

contract RealEstate {
    using SafeMath for uint256;
    
     //Property struct to store  information about a property
    struct Property {
        uint256 price;      // Price of the property
        address owner;      // Owner of the property
        bool forSale;       // Is the property for sale ?
        string name;        // Name of the property
        string description; // Description of the Property
        string location;    // Location of the property
    }
    
    // Mapping from property TDs to property structs
    mapping(uint256 => Property) public properties;
    
    // Array of all property IDs
    uint256[] public propertyIds;
    
    // Even for when a property is sold
    event PropertySold(uint256 propertyIds);
    
    // Function to list a new property for sale
    function listPropertyForSale(uint256 _propertyId, uint256 _price, string memory _description, string memory _location) public {
        //Create a new property struct and populate its fields
        Property memory newProperty = Property({
            price: _price,
            owner: msg.sender,
            forSale: true,
            name: _name,
            description: _description,
            location: _location
            
        });
        
        //Add the new property to the mapping and array of property IDs
        properties[_propertyId] = newProperty;
        propertyIds.push(_propertyId);
    }
     // Function to buy a listed property
    function buyProperty(uint256 _propertyId) public payable {
        
        // Retrieve the property struct  from the mapping 
        Property storage property = properties[_propertyId];

        // Check that the property is for sale and that the buyer has succifient funds
        require(property.forSale, "Property is not for sale");
        require(property.price <= msg.value, "Insufficient funds");

        // Transfer onwership of the property to the buyer and mark it as not for sale 
        property.owner = msg.sender;
        property.forSale = false;
        
        // Transfer the purchase price to the seller
        payable(property.owner).transfer(property.price);

        // Emit the PropertySold event 
        emit PropertySold(_propertyId);
    }
}

