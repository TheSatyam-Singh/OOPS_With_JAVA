package com.jibble;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle canceling leave requests
 */
public class CancelLeaveServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String leaveIdStr = request.getParameter("leaveId");
        String message = "";
        
        // Validation
        if (leaveIdStr == null || leaveIdStr.isEmpty()) {
            message = "Invalid leave ID";
        } else {
            try {
                int leaveId = Integer.parseInt(leaveIdStr);
                Connection conn = DBConnection.getConnection();
                
                // Check if leave belongs to user and is Pending
                String checkSql = "SELECT status FROM leave_requests WHERE id = ? AND user_id = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setInt(1, leaveId);
                checkStmt.setInt(2, userId);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    String status = rs.getString("status");
                    if ("Pending".equals(status)) {
                        // Delete the leave request
                        String deleteSql = "DELETE FROM leave_requests WHERE id = ? AND user_id = ?";
                        PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                        deleteStmt.setInt(1, leaveId);
                        deleteStmt.setInt(2, userId);
                        
                        int result = deleteStmt.executeUpdate();
                        
                        if (result > 0) {
                            message = "success:Leave request canceled successfully!";
                        } else {
                            message = "Failed to cancel leave request";
                        }
                        deleteStmt.close();
                    } else {
                        message = "Cannot cancel " + status + " leave requests";
                    }
                } else {
                    message = "Leave request not found";
                }
                
                rs.close();
                checkStmt.close();
                conn.close();
                
            } catch (NumberFormatException e) {
                message = "Invalid leave ID format";
            } catch (SQLException e) {
                message = "Database error: " + e.getMessage();
                e.printStackTrace();
            }
        }
        
        request.getSession().setAttribute("message", message);
        response.sendRedirect("leave-requests");
    }
}
