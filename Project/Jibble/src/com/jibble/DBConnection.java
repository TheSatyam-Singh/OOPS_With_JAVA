package com.jibble;

import java.sql.*;

/**
 * Utility class to manage database connections
 */
public class DBConnection {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/employee_db";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "satyam"; // Change if needed
    
    // Load MySQL driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Get database connection
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
    }
}
