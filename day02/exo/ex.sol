// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ProductsInfo {
    struct Product {
        uint256 id;
        string name;
        uint256 quantity;
    }

    Product[] private products;
    mapping(uint256 => uint256) private idToIndex;

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

    function getAllProductWithQuantities()
        public
        view
        returns (Product[] memory)
    {
        uint256 count = 0;

        for (uint256 i = 0; i < products.length; i++) {
            if (products[i].quantity > 0) {
                count++;
            }
        }

        Product[] memory productsWithQuantities = new Product[](count);

        uint256 index = 0;
        for (uint256 i = 0; i < products.length; i++) {
            if (products[i].quantity > 0) {
                productsWithQuantities[index] = products[i];
                index++;
            }
        }

        return productsWithQuantities;
    }

    function updateProduct(uint256 id, uint256 quantity) public {
        require(products.length > id, "Product not found.");
        products[id].quantity = quantity;
    }

    function deleteById(uint256 _id) public {
        uint256 index = idToIndex[_id];
        require(index < products.length, "Product not found.");

        products[index] = products[products.length - 1];
        products.pop();

        idToIndex[products[index].id] = index;
        delete idToIndex[_id];
    }
}
