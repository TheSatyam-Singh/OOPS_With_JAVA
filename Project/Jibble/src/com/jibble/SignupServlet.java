package com.jibble;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle user signup/registration
 */
public class SignupServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String confirmPassword = request.getParameter("confirmPassword").trim();
        String message = "";
        String status = "error";
        
        // Validation
        if (fullName.isEmpty() || email.isEmpty() || username.isEmpty() || password.isEmpty()) {
            message = "All fields are required";
        } else if (!password.equals(confirmPassword)) {
            message = "Passwords do not match";
        } else if (password.length() < 6) {
            message = "Password must be at least 6 characters";
        } else {
            try {
                Connection conn = DBConnection.getConnection();
                
                // Check if username already exists
                String checkSql = "SELECT id FROM user_accounts WHERE username = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, username);
                ResultSet checkRs = checkStmt.executeQuery();
                
                if (checkRs.next()) {
                    message = "Username already exists. Please choose another.";
                } else {
                    // Insert new user
                    String insertSql = "INSERT INTO user_accounts (full_name, email, username, password) VALUES (?, ?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                    insertStmt.setString(1, fullName);
                    insertStmt.setString(2, email);
                    insertStmt.setString(3, username);
                    insertStmt.setString(4, password);
                    
                    int result = insertStmt.executeUpdate();
                    
                    if (result > 0) {
                        message = "Account created successfully! Please login.";
                        status = "success";
                        
                        insertStmt.close();
                        
                        // Redirect to login after 2 seconds
                        response.setHeader("Refresh", "2; url=login");
                    } else {
                        message = "Failed to create account";
                    }
                    
                    insertStmt.close();
                }
                
                checkRs.close();
                checkStmt.close();
                conn.close();
                
            } catch (SQLException e) {
                message = "Database error: " + e.getMessage();
                e.printStackTrace();
            }
        }
        
        request.setAttribute("message", message);
        request.setAttribute("status", status);
        RequestDispatcher dispatcher = request.getRequestDispatcher("signup.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("signup.jsp");
        dispatcher.forward(request, response);
    }
}
