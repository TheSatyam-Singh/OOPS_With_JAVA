package com.jibble;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle user login
 */
public class LoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usernameOrEmail = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String message = "";
        
        if (usernameOrEmail.isEmpty() || password.isEmpty()) {
            message = "Username/Email and password required";
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Check credentials - accept both username and email
            String sql = "SELECT id, full_name, username FROM user_accounts WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, usernameOrEmail);
            stmt.setString(2, usernameOrEmail);
            stmt.setString(3, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Login successful - set session
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("fullName", rs.getString("full_name"));
                
                // Redirect to dashboard
                response.sendRedirect("dashboard");
            } else {
                message = "Invalid username/email or password";
                request.setAttribute("message", message);
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.forward(request, response);
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }
}
