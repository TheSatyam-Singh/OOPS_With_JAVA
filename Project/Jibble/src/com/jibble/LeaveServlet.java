package com.jibble;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle leave requests
 */
public class LeaveServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String leaveDate = request.getParameter("leaveDate");
        String reason = request.getParameter("reason").trim();
        String message = "";
        String status = "error";
        
        // Validation
        if (leaveDate == null || leaveDate.isEmpty()) {
            message = "Please select leave date";
        } else if (reason == null || reason.isEmpty()) {
            message = "Please enter reason";
        } else {
            try {
                Connection conn = DBConnection.getConnection();
                
                // Insert leave request
                String sql = "INSERT INTO leave_requests (user_id, leave_date, reason) VALUES (?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setString(2, leaveDate);
                stmt.setString(3, reason);
                
                int result = stmt.executeUpdate();
                
                if (result > 0) {
                    message = "Leave request submitted successfully";
                    status = "success";
                } else {
                    message = "Failed to submit leave request";
                }
                
                stmt.close();
                conn.close();
                
            } catch (SQLException e) {
                message = "Database error: " + e.getMessage();
                e.printStackTrace();
            }
        }
        
        request.setAttribute("message", message);
        request.setAttribute("status", status);
        response.sendRedirect("dashboard");
    }
}
