// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the App contract
// import "./User.sol";

interface User {
    enum Role {
        Farmer,
        Distributor,
        Vendor
    }

    function Register_User_Type(string calldata name, string calldata email, Role role) external;
    function Get_User_Role(address add) external view returns (uint);
    function Get_User_Name(address add) external view returns (string memory);
}

contract Farmer {
    User public User_Contract;

    constructor(address _UserAddress) {
        User_Contract = User(_UserAddress);
    }

    struct Farmer_Post {
        uint Farmer_Post_id;
        address Farmer_address;
        string img;
        string Product_name;
        string Product_description;
        uint Product_quantity;
        uint Farmer_price;
        address[] from;
        string[] from_name;
        address[] to;
        string[] to_name;
        uint[] value;
        uint status;
    }

    uint public Farmer_Post_Counter;

    Farmer_Post[] public Farmer_Post_Array;

    mapping(address => uint[]) public Farmer_Own_Post;

    function Farmer_Post_Create(string memory Product_name, string memory Product_description, uint Product_quantity, string memory img, uint Farmer_price) public {
        require(User_Contract.Get_User_Role(msg.sender) == 0, "You are not the Farmer");
        // if(Farmer_Post_Counter == 0) {
        //     Farmer_Post_Counter++;
        //     Farmer_Post_Array.push();
        //     Farmer_Own_Post[msg.sender].push();
        // }
        Farmer_Post memory Farmer_Post1;
        Farmer_Post1.Farmer_Post_id = Farmer_Post_Counter;
        Farmer_Post1.Farmer_address = payable(msg.sender);
        Farmer_Post1.img = img;
        Farmer_Post1.Product_name = Product_name;
        Farmer_Post1.Product_description = Product_description;
        Farmer_Post1.Product_quantity = Product_quantity;
        Farmer_Post1.Farmer_price = Farmer_price;
        Farmer_Post_Array.push(Farmer_Post1);
        Farmer_Own_Post[msg.sender].push(Farmer_Post_Counter);
        Farmer_Post_Counter = Farmer_Post_Counter + 1;
    }

    function Transfer_to_Farmer(uint Farmer_Post_id) public payable {
        require(User_Contract.Get_User_Role(msg.sender) == 1, "You are not the Distributor");
        payable(Farmer_Post_Array[Farmer_Post_id].Farmer_address).transfer(msg.value);
        Farmer_Post_Array[Farmer_Post_id].from.push(msg.sender);
        Farmer_Post_Array[Farmer_Post_id].from_name.push(string(abi.encodePacked(User_Contract.Get_User_Name(msg.sender),"(Distributor)")));
        Farmer_Post_Array[Farmer_Post_id].to.push(Farmer_Post_Array[Farmer_Post_id].Farmer_address);
        Farmer_Post_Array[Farmer_Post_id].to_name.push(string(abi.encodePacked(User_Contract.Get_User_Name(Farmer_Post_Array[Farmer_Post_id].Farmer_address),"(Farmer)")));
        Farmer_Post_Array[Farmer_Post_id].value.push(msg.value);
        Farmer_Post_Array[Farmer_Post_id].status = 1;
        Farmer_Own_Post[msg.sender].push(Farmer_Post_id);
        // Farmer_Own_Post[Farmer_Post_Array[Farmer_Post_id].Farmer_address][Farmer_Post_id] = 0;
    }

    function Farmer_Post_Display(uint Farmer_Post_id) public view returns (
        string memory, string memory, uint
    ) {
        Farmer_Post memory post = Farmer_Post_Array[Farmer_Post_id];
        return (
            post.Product_name,
            post.Product_description,
            post.Product_quantity
        );
    }

    function Farmer_Array_Update(uint Distributor_Post_id, address Distributor_Address, uint value) public {
        Farmer_Post_Array[Distributor_Post_id].from.push(msg.sender);
        Farmer_Post_Array[Distributor_Post_id].from_name.push(string(abi.encodePacked(User_Contract.Get_User_Name(msg.sender),"(Vendor)")));
        Farmer_Post_Array[Distributor_Post_id].to.push(Distributor_Address);
        Farmer_Post_Array[Distributor_Post_id].to_name.push(string(abi.encodePacked(User_Contract.Get_User_Name(Distributor_Address),"(Distributor)")));
        Farmer_Post_Array[Distributor_Post_id].value.push(value);
    }

    function getAllFarmerPosts() public view returns (Farmer_Post[] memory) {
        uint unprocessedCount = 0;

        // Count unprocessed (status == false) posts
        for (uint i = 0; i < Farmer_Post_Array.length; i++) {
            if (Farmer_Post_Array[i].status == 0) {
                unprocessedCount++;
            }
        }

        Farmer_Post[] memory unprocessedPosts = new Farmer_Post[](unprocessedCount);
        uint currentIndex = 0;

        // Populate unprocessed posts
        for (uint i = 0; i < Farmer_Post_Array.length; i++) {
            if (Farmer_Post_Array[i].status == 0) {
                unprocessedPosts[currentIndex] = Farmer_Post_Array[i];
                currentIndex++;
            }
        }

        return unprocessedPosts;
    }

    function getFarmerPosts(address _farmerAddress, uint num) public view returns (Farmer_Post[] memory) {
        uint[] memory postIds = Farmer_Own_Post[_farmerAddress];

        if (num == 0) {
            // Retrieve all posts for the given farmer address
            Farmer_Post[] memory posts = new Farmer_Post[](postIds.length);
            for (uint i = 0; i < postIds.length; i++) {
                posts[i] = Farmer_Post_Array[postIds[i]];
            }
            return posts;
        } else if (num == 1) {
            uint validPostCount = 0;

            // Count valid posts with status 1 (assuming status 1 means the post is valid)
            for (uint i = 0; i < postIds.length; i++) {
                if (Farmer_Post_Array[postIds[i]].status == 1) {
                    validPostCount++;
                }
            }

            Farmer_Post[] memory posts = new Farmer_Post[](validPostCount);
            uint validIndex = 0;

            // Populate valid posts with status 1
            for (uint i = 0; i < postIds.length; i++) {
                if (Farmer_Post_Array[postIds[i]].status == 1) {
                    posts[validIndex] = Farmer_Post_Array[postIds[i]];
                    validIndex++;
                }
            }
            return posts;
        } else {
            revert("Invalid input");
        }
    }

    function update_Status(uint Farmer_Post_id, uint num) public {
        Farmer_Post_Array[Farmer_Post_id].status = num;
    }

    function getTransactions(uint256 _id) public view returns (address[] memory, string[] memory, address[] memory, string[] memory, uint256[] memory) {
        return (Farmer_Post_Array[_id].from, Farmer_Post_Array[_id].from_name, Farmer_Post_Array[_id].to, Farmer_Post_Array[_id].to_name, Farmer_Post_Array[_id].value);
    }

    // Function to get the uint array associated with the sender's address
    // function getFarmerOwnPost() public view returns (uint[] memory) {
    //     return Farmer_Own_Post[msg.sender];
    // }
}
