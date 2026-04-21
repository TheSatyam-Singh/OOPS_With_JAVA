package com.jibble;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle edit leave request form
 */
public class EditLeaveServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String leaveIdStr = request.getParameter("id");
        Map<String, String> leave = new HashMap<>();
        String message = "";
        
        try {
            int leaveId = Integer.parseInt(leaveIdStr);
            Connection conn = DBConnection.getConnection();
            
            // Fetch leave request
            String sql = "SELECT id, leave_from, leave_to, reason, status FROM leave_requests WHERE id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, leaveId);
            stmt.setInt(2, userId);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("status");
                // Only allow editing if Pending
                if ("Pending".equals(status)) {
                    leave.put("id", String.valueOf(rs.getInt("id")));
                    leave.put("leave_from", rs.getDate("leave_from").toString());
                    leave.put("leave_to", rs.getDate("leave_to").toString());
                    leave.put("reason", rs.getString("reason"));
                    leave.put("status", status);
                } else {
                    message = "Cannot edit " + status + " leave requests";
                }
            } else {
                message = "Leave request not found";
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (NumberFormatException e) {
            message = "Invalid leave ID";
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            e.printStackTrace();
        }
        
        request.setAttribute("leave", leave);
        request.setAttribute("message", message);
        request.getRequestDispatcher("edit-leave.jsp").forward(request, response);
    }
}
