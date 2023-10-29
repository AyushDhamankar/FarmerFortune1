// SPDX-License-Identifier: MIT 
// 0xd9145CCE52D386f254917e481eB44e9943F39138
pragma solidity >=0.5.0 < 0.9.0;

contract User {
    enum Role {
        Farmer,
        Distributor,
        Vendor
    }

    struct User_Type {
        uint id;
        string name;
        string email;
        Role role;
    }

    uint public User_Type_Counter;

    mapping (address => User_Type) public User_Type_Mapping;

    function Register_User_Type(string calldata name, string calldata email, Role role) public {
        require(bytes(User_Type_Mapping[msg.sender].name).length == 0, "You are already registered");
        User_Type memory User_Type1;
        User_Type1.id = User_Type_Counter++;
        User_Type1.name = name;
        User_Type1.email = email;
        User_Type1.role = role;
        User_Type_Mapping[msg.sender] = User_Type1;
    }

    function Get_User_Role(address add) public view returns(uint) {
        return uint(User_Type_Mapping[add].role);
    }

    function Get_User_Name(address add) public view returns(string memory) {
        return User_Type_Mapping[add].name;
    }
}