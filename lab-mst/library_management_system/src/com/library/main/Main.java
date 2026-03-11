package com.library.main;

import com.library.books.Book;
import com.library.exception.BookNotAvailableException;
import com.library.exception.BookNotFoundException;
import com.library.service.LibraryService;

public class Main {
    public static void main(String[] args) {
        LibraryService service = new LibraryService();

        try {
            System.out.println("=== Adding Books ===");
            service.addBook(new Book(1, "Java Programming", "John Doe", 5));
            service.addBook(new Book(2, "Data Structures", "Jane Smith", 3));
            service.addBook(new Book(3, "Algorithms", "Bob Johnson", 0));
            System.out.println("Books added successfully.\n");

            System.out.println("=== Viewing All Books ===");
            service.viewBooks();
            System.out.println();

            System.out.println("=== Issuing Book (ID: 1) ===");
            service.issueBook(1);
            System.out.println("Book issued successfully.\n");

            System.out.println("=== Viewing Books After Issue ===");
            service.viewBooks();
            System.out.println();

            System.out.println("=== Returning Book (ID: 1) ===");
            service.returnBook(1);
            System.out.println("Book returned successfully.\n");

            System.out.println("=== Viewing Books After Return ===");
            service.viewBooks();
            System.out.println();

            System.out.println("=== Attempting to Issue Unavailable Book (ID: 3) ===");
            service.issueBook(3);

        } catch (BookNotFoundException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (BookNotAvailableException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

        try {
            System.out.println("\n=== Attempting to Issue Non-Existent Book (ID: 99) ===");
            service.issueBook(99);
        } catch (BookNotFoundException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (BookNotAvailableException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
