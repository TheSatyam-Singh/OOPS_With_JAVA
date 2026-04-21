package com.jibble;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle clock-out operation
 */
public class ClockOutServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String message = "";
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // First, get the latest active clock-in record ID
            String getIdSql = "SELECT id FROM attendance WHERE user_id = ? AND clock_out IS NULL ORDER BY clock_in DESC LIMIT 1";
            PreparedStatement getIdStmt = conn.prepareStatement(getIdSql);
            getIdStmt.setInt(1, userId);
            ResultSet rs = getIdStmt.executeQuery();
            
            int recordId = -1;
            if (rs.next()) {
                recordId = rs.getInt("id");
            }
            rs.close();
            getIdStmt.close();
            
            // Update using the ID we found
            int result = 0;
            if (recordId > 0) {
                String sql = "UPDATE attendance SET clock_out = NOW() WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, recordId);
                result = stmt.executeUpdate();
                stmt.close();
            }
            
            if (result > 0) {
                message = "success:Clock-out successful!";
            } else {
                message = "No active clock-in found";
            }
            conn.close();
            
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
            e.printStackTrace();
        }
        
        session.setAttribute("message", message);
        response.sendRedirect("dashboard");
    }
}
