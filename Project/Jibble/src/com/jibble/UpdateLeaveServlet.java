package com.jibble;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle updating leave requests
 */
public class UpdateLeaveServlet extends HttpServlet {
    
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
        String leaveFrom = request.getParameter("leaveFrom");
        String leaveTo = request.getParameter("leaveTo");
        String reason = request.getParameter("reason").trim();
        String message = "";
        
        // Validation
        if (leaveIdStr == null || leaveIdStr.isEmpty()) {
            message = "Invalid leave ID";
        } else if (leaveFrom == null || leaveFrom.isEmpty()) {
            message = "Please select 'From' date";
        } else if (leaveTo == null || leaveTo.isEmpty()) {
            message = "Please select 'To' date";
        } else if (reason == null || reason.isEmpty()) {
            message = "Please enter reason";
        } else if (reason.length() > 255) {
            message = "Reason must be less than 255 characters";
        } else {
            try {
                int leaveId = Integer.parseInt(leaveIdStr);
                Connection conn = DBConnection.getConnection();
                
                // Verify leave is Pending and belongs to user
                String checkSql = "SELECT status FROM leave_requests WHERE id = ? AND user_id = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setInt(1, leaveId);
                checkStmt.setInt(2, userId);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    String status = rs.getString("status");
                    if ("Pending".equals(status)) {
                        // Update leave request
                        String sql = "UPDATE leave_requests SET leave_from = ?, leave_to = ?, reason = ? WHERE id = ? AND user_id = ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setString(1, leaveFrom);
                        stmt.setString(2, leaveTo);
                        stmt.setString(3, reason);
                        stmt.setInt(4, leaveId);
                        stmt.setInt(5, userId);
                        
                        int result = stmt.executeUpdate();
                        
                        if (result > 0) {
                            message = "success:Leave request updated successfully!";
                        } else {
                            message = "Failed to update leave request";
                        }
                        stmt.close();
                    } else {
                        message = "Cannot edit " + status + " leave requests";
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
