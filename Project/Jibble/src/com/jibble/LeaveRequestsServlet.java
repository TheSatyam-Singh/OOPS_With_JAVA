package com.jibble;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to manage leave requests on dedicated page
 */
public class LeaveRequestsServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        List<Map<String, String>> leaveRequests = new ArrayList<>();
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Fetch leave requests
            String sql = "SELECT id, leave_from, leave_to, reason, status FROM leave_requests WHERE user_id = ? ORDER BY leave_from DESC LIMIT 20";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> leave = new HashMap<>();
                leave.put("id", String.valueOf(rs.getInt("id")));
                leave.put("leave_from", rs.getDate("leave_from").toString());
                leave.put("leave_to", rs.getDate("leave_to").toString());
                leave.put("reason", rs.getString("reason"));
                leave.put("status", rs.getString("status"));
                leaveRequests.add(leave);
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        request.setAttribute("leaveRequests", leaveRequests);
        request.getRequestDispatcher("leave-requests.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String leaveFrom = request.getParameter("leaveFrom");
        String leaveTo = request.getParameter("leaveTo");
        String reason = request.getParameter("reason").trim();
        String message = "";
        
        // Validation
        if (leaveFrom == null || leaveFrom.isEmpty()) {
            message = "Please select 'From' date";
        } else if (leaveTo == null || leaveTo.isEmpty()) {
            message = "Please select 'To' date";
        } else if (reason == null || reason.isEmpty()) {
            message = "Please enter reason";
        } else if (reason.length() > 255) {
            message = "Reason must be less than 255 characters";
        } else {
            try {
                Connection conn = DBConnection.getConnection();
                
                // Insert leave request
                String sql = "INSERT INTO leave_requests (user_id, leave_from, leave_to, reason) VALUES (?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setString(2, leaveFrom);
                stmt.setString(3, leaveTo);
                stmt.setString(4, reason);
                
                int result = stmt.executeUpdate();
                
                if (result > 0) {
                    message = "success:Leave request submitted";
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
        doGet(request, response);
    }
}
