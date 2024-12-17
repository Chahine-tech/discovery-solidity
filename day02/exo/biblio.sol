// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DecentralizedLibrary {
    struct Book {
        string title;
        uint256 copies;
        bool exists;
    }

    mapping(uint256 => Book) private books;

    event BookAdded(uint256 isbn, string title, uint256 copies);
    event BookUpdated(uint256 isbn, uint256 newCopies);
    event CopiesAdded(uint256 isbn, uint256 additionalCopies);

    function addBook(uint256 isbn, string memory title, uint256 copies) public {
        require(!books[isbn].exists, "Book with this ISBN already exists");
        books[isbn] = Book(title, copies, true);
        emit BookAdded(isbn, title, copies);
    }

   
    function updateCopies(uint256 isbn, uint256 newCopies) public {
        require(books[isbn].exists, "Book with this ISBN does not exist");
        books[isbn].copies = newCopies;
        emit BookUpdated(isbn, newCopies);
    }

    function getBook(uint256 isbn) public view returns (Book memory) {
        require(books[isbn].exists, "Book with this ISBN does not exist");
        return books[isbn];
    }

    function addCopies(uint256 isbn, uint256 additionalCopies) public {
        require(books[isbn].exists, "Book with this ISBN does not exist");
        books[isbn].copies += additionalCopies;
        emit CopiesAdded(isbn, additionalCopies);
    }
}