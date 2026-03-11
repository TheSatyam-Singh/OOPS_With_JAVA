package com.library.service;

import com.library.books.Book;
import com.library.exception.BookNotAvailableException;
import com.library.exception.BookNotFoundException;
import java.io.*;
import java.util.*;

public class LibraryService {
    private static final String FILE_PATH = "books.txt";

    public void addBook(Book b) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(b.getBookId() + "," + b.getTitle() + "," + b.getAuthor() + "," + b.getAvailableCopies());
            writer.newLine();
        }
    }

    public void viewBooks() throws IOException {
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            System.out.println("No books available.");
            return;
        }
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                System.out.println("Book ID: " + parts[0] + ", Title: " + parts[1] + ", Author: " + parts[2] + ", Available Copies: " + parts[3]);
            }
        }
    }

    public void issueBook(int bookId) throws IOException, BookNotFoundException, BookNotAvailableException {
        List<String> lines = new ArrayList<>();
        boolean found = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (Integer.parseInt(parts[0]) == bookId) {
                    found = true;
                    int copies = Integer.parseInt(parts[3]);
                    if (copies == 0) {
                        throw new BookNotAvailableException("Book with ID " + bookId + " is not available.");
                    }
                    copies--;
                    lines.add(parts[0] + "," + parts[1] + "," + parts[2] + "," + copies);
                } else {
                    lines.add(line);
                }
            }
        }

        if (!found) {
            throw new BookNotFoundException("Book with ID " + bookId + " not found.");
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    public void returnBook(int bookId) throws IOException, BookNotFoundException {
        List<String> lines = new ArrayList<>();
        boolean found = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (Integer.parseInt(parts[0]) == bookId) {
                    found = true;
                    int copies = Integer.parseInt(parts[3]) + 1;
                    lines.add(parts[0] + "," + parts[1] + "," + parts[2] + "," + copies);
                } else {
                    lines.add(line);
                }
            }
        }

        if (!found) {
            throw new BookNotFoundException("Book with ID " + bookId + " not found.");
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        }
    }
}
