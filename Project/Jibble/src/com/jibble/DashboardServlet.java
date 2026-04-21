package com.jibble;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to display employee dashboard
 */
public class DashboardServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        List<Map<String, String>> attendanceRecords = new ArrayList<>();
        List<Map<String, String>> leaveRequests = new ArrayList<>();
        boolean isClockedIn = false;
        String activeClockInTime = null;
        int pendingLeaveCount = 0;
        int approvedLeaveCount = 0;
        
        try {
            Connection conn = DBConnection.getConnection();
            
            String activeAttendanceSql =
                    "SELECT clock_in FROM attendance WHERE user_id = ? AND clock_out IS NULL ORDER BY clock_in DESC LIMIT 1";
            PreparedStatement activeAttendanceStmt = conn.prepareStatement(activeAttendanceSql);
            activeAttendanceStmt.setInt(1, userId);
            ResultSet activeAttendanceRs = activeAttendanceStmt.executeQuery();
            
            if (activeAttendanceRs.next()) {
                Timestamp activeClockIn = activeAttendanceRs.getTimestamp("clock_in");
                isClockedIn = true;
                activeClockInTime = activeClockIn != null ? activeClockIn.toString() : null;
            }
            
            activeAttendanceRs.close();
            activeAttendanceStmt.close();
            
            // Fetch attendance records
            String attendanceSql = "SELECT id, clock_in, clock_out FROM attendance WHERE user_id = ? ORDER BY clock_in DESC LIMIT 10";
            PreparedStatement attendanceStmt = conn.prepareStatement(attendanceSql);
            attendanceStmt.setInt(1, userId);
            ResultSet attendanceRs = attendanceStmt.executeQuery();
            
            while (attendanceRs.next()) {
                Map<String, String> record = new HashMap<>();
                record.put("id", String.valueOf(attendanceRs.getInt("id")));
                record.put("clock_in", attendanceRs.getTimestamp("clock_in") != null ? attendanceRs.getTimestamp("clock_in").toString() : "N/A");
                record.put("clock_out", attendanceRs.getTimestamp("clock_out") != null ? attendanceRs.getTimestamp("clock_out").toString() : "Still Clocked In");
                attendanceRecords.add(record);
            }
            
            attendanceRs.close();
            attendanceStmt.close();
            
            // Fetch leave requests
            String leaveSql = "SELECT id, leave_from, leave_to, reason, status FROM leave_requests WHERE user_id = ? ORDER BY leave_from DESC LIMIT 10";
            PreparedStatement leaveStmt = conn.prepareStatement(leaveSql);
            leaveStmt.setInt(1, userId);
            ResultSet leaveRs = leaveStmt.executeQuery();
            
            while (leaveRs.next()) {
                Map<String, String> leave = new HashMap<>();
                leave.put("id", String.valueOf(leaveRs.getInt("id")));
                leave.put("leave_from", leaveRs.getDate("leave_from").toString());
                leave.put("leave_to", leaveRs.getDate("leave_to").toString());
                leave.put("reason", leaveRs.getString("reason"));
                leave.put("status", leaveRs.getString("status"));
                leaveRequests.add(leave);
            }
            
            leaveRs.close();
            leaveStmt.close();
            
            String leaveCountSql =
                    "SELECT " +
                    "SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_count, " +
                    "SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END) AS approved_count " +
                    "FROM leave_requests WHERE user_id = ?";
            PreparedStatement leaveCountStmt = conn.prepareStatement(leaveCountSql);
            leaveCountStmt.setInt(1, userId);
            ResultSet leaveCountRs = leaveCountStmt.executeQuery();
            
            if (leaveCountRs.next()) {
                pendingLeaveCount = leaveCountRs.getInt("pending_count");
                approvedLeaveCount = leaveCountRs.getInt("approved_count");
            }
            
            leaveCountRs.close();
            leaveCountStmt.close();
            conn.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        request.setAttribute("isClockedIn", isClockedIn);
        request.setAttribute("activeClockInTime", activeClockInTime);
        request.setAttribute("pendingLeaveCount", pendingLeaveCount);
        request.setAttribute("approvedLeaveCount", approvedLeaveCount);
        request.setAttribute("attendanceRecords", attendanceRecords);
        request.setAttribute("leaveRequests", leaveRequests);
        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
