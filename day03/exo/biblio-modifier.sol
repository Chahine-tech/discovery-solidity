// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DecentralizedLibrary {
    struct Book {
        string title;
        uint256 copies;
        bool exists;
    }

    address public owner;
    mapping(uint256 => Book) private books;
    uint256[] private bookISBNs;

    event BookAdded(uint256 isbn, string title, uint256 copies);
    event BookUpdated(uint256 isbn, uint256 newCopies);
    event CopiesAdded(uint256 isbn, uint256 additionalCopies);
    event CopiesRemoved(uint256 isbn, uint256 removedCopies);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function addBook(
        uint256 isbn,
        string memory title,
        uint256 copies
    ) public onlyOwner {
        require(!books[isbn].exists, "Book with this ISBN already exists");
        books[isbn] = Book(title, copies, true);
        bookISBNs.push(isbn);
        emit BookAdded(isbn, title, copies);
    }

    function updateCopies(uint256 isbn, uint256 newCopies) public onlyOwner {
        require(books[isbn].exists, "Book with this ISBN does not exist");
        books[isbn].copies = newCopies;
        emit BookUpdated(isbn, newCopies);
    }

    function getBook(uint256 isbn) public view returns (Book memory) {
        require(books[isbn].exists, "Book with this ISBN does not exist");
        return books[isbn];
    }

    function addCopies(uint256 isbn, uint256 additionalCopies) public onlyOwner {
        require(books[isbn].exists, "Book with this ISBN does not exist");
        books[isbn].copies += additionalCopies;
        emit CopiesAdded(isbn, additionalCopies);
    }

    function getAllISBNs() public view returns (uint256[] memory) {
        return bookISBNs;
    }

    function bookExists(uint256 isbn) public view returns (bool) {
        return books[isbn].exists && bytes(books[isbn].title).length > 0;
    }

    function removeCopies(uint256 isbn, uint256 removedCopies) public onlyOwner {
        require(books[isbn].exists, "Book with this ISBN does not exist");
        require(
            books[isbn].copies >= removedCopies,
            "Not enough copies to remove"
        );
        books[isbn].copies -= removedCopies;
        emit CopiesRemoved(isbn, removedCopies);
    }
}