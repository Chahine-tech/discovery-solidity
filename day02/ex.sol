// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ProductsInfo {
    struct Product {
        uint256 id;
        string name;
        uint256 quantity;
    }

    Product[] private products;

    constructor() {}

    function addProduct(
        uint256 _id,
        string memory _name,
        uint256 _quantity
    ) public {
        products.push(Product(_id, _name, _quantity));
    }

    function removeLastProduct() public {
        require(products.length > 0, "No products in the inventory to remove.");
        products.pop();
    }

    function getProductByIndex(uint256 index)
        public
        view
        returns (Product memory)
    {
        require(index < products.length, "Index out of bounds.");
        return products[index];
    }

    function getProductCount() public view returns (uint256) {
        return products.length;
    }

    function getAllProducts() public view returns (Product[] memory) {
        return products;
    }

    function updateProduct(
        uint256 id,
        uint256 quantity
    ) public {
       require(products.length > id, "Product not found.");
       products[id].quantity = quantity;
    }
}
