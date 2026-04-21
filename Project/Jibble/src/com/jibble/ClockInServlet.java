package com.jibble;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to handle clock-in operation
 */
public class ClockInServlet extends HttpServlet {
    
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
        Connection conn = null;
        PreparedStatement lockStmt = null;
        PreparedStatement checkStmt = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Lock the user row so concurrent clock-in requests cannot create
            // multiple active attendance records for the same employee.
            String lockSql = "SELECT id FROM user_accounts WHERE id = ? FOR UPDATE";
            lockStmt = conn.prepareStatement(lockSql);
            lockStmt.setInt(1, userId);
            lockStmt.executeQuery().close();
            
            // Check if user already has an active clock-in (not clocked out yet)
            String checkSql = "SELECT id FROM attendance WHERE user_id = ? AND clock_out IS NULL";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                message = "You are already clocked in. Please clock out before clocking in again.";
                conn.rollback();
                session.setAttribute("message", message);
                response.sendRedirect("dashboard");
                return;
            }
            
            // Insert clock-in record
            String sql = "INSERT INTO attendance (user_id, clock_in) VALUES (?, NOW())";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                message = "success:Clock-in successful!";
                conn.commit();
            } else {
                message = "Clock-in failed";
                conn.rollback();
            }
            
            session.setAttribute("message", message);
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }
            message = "Database error: " + e.getMessage();
            session.setAttribute("message", message);
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (stmt != null) stmt.close();
                if (lockStmt != null) lockStmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException closeException) {
                closeException.printStackTrace();
            }
        }
        
        response.sendRedirect("dashboard");
    }
}
