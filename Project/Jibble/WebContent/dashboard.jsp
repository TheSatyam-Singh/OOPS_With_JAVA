<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - TimeTrack Employee System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f8f9fa;
            color: #2c3e50;
        }
        
        .header {
            background-color: #fff;
            border-bottom: 1px solid #e8eaed;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        
        .header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 600;
            color: #1a73e8;
        }
        
        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            text-align: right;
        }
        
        .user-name {
            font-weight: 500;
            font-size: 14px;
            color: #202124;
        }
        
        .user-email {
            font-size: 12px;
            color: #5f6368;
        }
        
        .logout-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background-color 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        
        .logout-btn:hover {
            background-color: #c82333;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
        }
        
        .welcome-section {
            margin-bottom: 32px;
        }
        
        .welcome-title {
            font-size: 28px;
            font-weight: 400;
            color: #202124;
            margin-bottom: 4px;
        }
        
        .welcome-subtitle {
            font-size: 14px;
            color: #5f6368;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 16px;
            margin-bottom: 32px;
        }
        
        .stat-card {
            background: white;
            border: 1px solid #e8eaed;
            border-radius: 8px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            transition: box-shadow 0.2s;
        }
        
        .stat-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.12);
        }
        
        .stat-icon {
            font-size: 32px;
            width: 56px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f1f3f4;
            border-radius: 8px;
        }
        
        .stat-info h3 {
            font-size: 12px;
            color: #5f6368;
            font-weight: 500;
            text-transform: uppercase;
            margin-bottom: 6px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: #1a73e8;
        }
        
        .message {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-size: 13px;
            border-left: 4px solid;
            font-weight: 500;
            display: none;
        }
        
        .message.error {
            background-color: #fce5e6;
            color: #c5221f;
            border-left-color: #d33b27;
            display: block;
        }
        
        .message.success {
            background-color: #d2e7d6;
            color: #0d652d;
            border-left-color: #34a853;
            display: block;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 12px;
            margin-bottom: 32px;
        }
        
        .btn {
            padding: 12px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-primary {
            background-color: #1a73e8;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #1557b0;
            box-shadow: 0 2px 6px rgba(26, 115, 232, 0.3);
        }
        
        .btn-success {
            background-color: #34a853;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #2d8e47;
            box-shadow: 0 2px 6px rgba(52, 168, 83, 0.3);
        }
        
        .btn-warning {
            background-color: #ea8600;
            color: white;
        }
        
        .btn-warning:hover {
            background-color: #d37600;
            box-shadow: 0 2px 6px rgba(234, 134, 0, 0.3);
        }
        
        .section {
            background: white;
            border: 1px solid #e8eaed;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        
        .section h2 {
            font-size: 16px;
            font-weight: 500;
            color: #202124;
            margin-bottom: 20px;
            border-bottom: 2px solid #e8eaed;
            padding-bottom: 12px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        
        table th {
            background-color: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #5f6368;
            border-bottom: 2px solid #dadce0;
            font-size: 13px;
        }
        
        table td {
            padding: 14px 12px;
            border-bottom: 1px solid #dadce0;
        }
        
        table tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-active {
            background-color: #fce5cd;
            color: #9d6d00;
        }
        
        .badge-completed {
            background-color: #d2e7d6;
            color: #0d652d;
        }
        
        .badge-pending {
            background-color: #e8f0fe;
            color: #1a73e8;
        }
        
        .badge-approved {
            background-color: #d2e7d6;
            color: #0d652d;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #5f6368;
        }
        
        .time-value {
            font-weight: 500;
            color: #34a853;
        }
        
        .still-active {
            color: #ea8600;
            font-weight: 500;
            animation: pulse 1s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        
        .active-timer {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: #ea8600;
            font-weight: 600;
        }
        
        .timer-dot {
            width: 8px;
            height: 8px;
            background-color: #ea8600;
            border-radius: 50%;
            animation: blink 1s infinite;
        }
        
        @keyframes blink {
            0%, 50%, 100% { opacity: 1; }
            25%, 75% { opacity: 0.3; }
        }
        
        .grid-2 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 24px;
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 12px;
                align-items: flex-start;
            }
            
            .header-right {
                width: 100%;
                justify-content: space-between;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
            
            .grid-2 {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
        Boolean isClockedInObj = (Boolean) request.getAttribute("isClockedIn");
        boolean isClockedIn = isClockedInObj != null && isClockedInObj;
        String activeClockInTime = (String) request.getAttribute("activeClockInTime");
        Integer pendingLeaveCount = (Integer) request.getAttribute("pendingLeaveCount");
        Integer approvedLeaveCount = (Integer) request.getAttribute("approvedLeaveCount");
    %>
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <div class="logo">TimeTrack</div>
        </div>
        <div class="header-right">
            <div class="user-info">
                <div class="user-name"><%= session.getAttribute("fullName") %></div>
                <div class="user-email">Employee Dashboard</div>
            </div>
            <a href="logout" class="logout-btn">Sign Out</a>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="welcome-title">Welcome back, <%= session.getAttribute("fullName") %></div>
            <div class="welcome-subtitle">Here's your attendance summary for today</div>
        </div>
        
        <%
            String message = (String) session.getAttribute("message");
            if (message != null) {
                session.removeAttribute("message");
        %>
            <div class="message <%= message.startsWith("success:") ? "success" : "error" %>">
                <%= message.startsWith("success:") ? message.substring(8) : message %>
            </div>
        <% } %>
        
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">📊</div>
                <div class="stat-info">
                    <h3>Status Today</h3>
                    <div class="stat-value"><%= isClockedIn ? "Clocked In" : "Clocked Out" %></div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">⏱️</div>
                <div class="stat-info">
                    <h3>Time Elapsed</h3>
                    <div class="stat-value" id="timerDisplay">00:00:00</div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">📅</div>
                <div class="stat-info">
                    <h3>Pending Leaves</h3>
                    <div class="stat-value"><%= pendingLeaveCount != null ? pendingLeaveCount : 0 %></div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">✓</div>
                <div class="stat-info">
                    <h3>Approved Leaves</h3>
                    <div class="stat-value"><%= approvedLeaveCount != null ? approvedLeaveCount : 0 %></div>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="action-buttons">
            <form method="post" action="clockin" style="flex: 1;">
                <button type="submit" class="btn btn-success" style="width: 100%; opacity: <%= isClockedIn ? "0.65" : "1" %>;" <%= isClockedIn ? "disabled" : "" %>>
                    ▶ Clock In
                </button>
            </form>
            <form method="post" action="clockout" style="flex: 1;">
                <button type="submit" class="btn btn-primary" style="width: 100%; opacity: <%= isClockedIn ? "1" : "0.65" %>;" <%= isClockedIn ? "" : "disabled" %>>
                    ⏹ Clock Out
                </button>
            </form>
            <a href="leave-requests" class="btn btn-warning" style="flex: 1; width: 100%; text-decoration: none;">
                📋 Request Leave
            </a>
        </div>
        
        <!-- Content Grid -->
        <div class="grid-2">
            <!-- Attendance Section -->
            <div class="section">
                <h2>📊 Recent Attendance</h2>
                <%
                    List<Map<String, String>> attendanceRecords = (List<Map<String, String>>) request.getAttribute("attendanceRecords");
                %>
                
                <% if (attendanceRecords != null && !attendanceRecords.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Clock In</th>
                                <th>Clock Out</th>
                                <th>Duration</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, String> record : attendanceRecords) { 
                                String clockInTime = record.get("clock_in");
                                String clockOutTime = record.get("clock_out");
                                String date = clockInTime.substring(0, 10);
                                String clockInHMS = clockInTime.substring(11, 19);
                                String duration = "-";
                                
                                // Calculate duration if clocked out
                                if (!clockOutTime.equals("Still Clocked In")) {
                                    try {
                                        String clockOutHMS = clockOutTime.substring(11, 19);
                                        String[] inParts = clockInHMS.split(":");
                                        String[] outParts = clockOutHMS.split(":");
                                        
                                        int inSecs = Integer.parseInt(inParts[0]) * 3600 + Integer.parseInt(inParts[1]) * 60 + Integer.parseInt(inParts[2]);
                                        int outSecs = Integer.parseInt(outParts[0]) * 3600 + Integer.parseInt(outParts[1]) * 60 + Integer.parseInt(outParts[2]);
                                        
                                        int durationSecs = outSecs - inSecs;
                                        if (durationSecs < 0) durationSecs += 86400; // Handle day boundary
                                        
                                        int hours = durationSecs / 3600;
                                        int minutes = (durationSecs % 3600) / 60;
                                        int seconds = durationSecs % 60;
                                        
                                        duration = String.format("%02d:%02d:%02d", hours, minutes, seconds);
                                    } catch (Exception e) {
                                        duration = "-";
                                    }
                                }
                            %>
                                <tr>
                                    <td><%= date %></td>
                                    <td class="time-value"><%= clockInHMS %></td>
                                    <td>
                                        <% if (clockOutTime.equals("Still Clocked In")) { %>
                                            <span class="still-active">
                                                <span class="timer-dot"></span>
                                                Active
                                            </span>
                                        <% } else { %>
                                            <span class="time-value"><%= clockOutTime.substring(11, 19) %></span>
                                        <% } %>
                                    </td>
                                    <td class="time-value">
                                        <% if (clockOutTime.equals("Still Clocked In")) { %>
                                            <span style="color: #ea8600; font-weight: 500;">Running...</span>
                                        <% } else { %>
                                            <%= duration %>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (clockOutTime.equals("Still Clocked In")) { %>
                                            <span class="badge badge-active">Ongoing</span>
                                        <% } else { %>
                                            <span class="badge badge-completed">Completed</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <p>No attendance records yet. Start by clicking "Clock In" button.</p>
                    </div>
                <% } %>
            </div>
            
            <!-- Leave Requests Section -->
            <div class="section">
                <h2>📋 Leave Requests</h2>
                <%
                    List<Map<String, String>> leaveRequests = (List<Map<String, String>>) request.getAttribute("leaveRequests");
                %>
                
                <% if (leaveRequests != null && !leaveRequests.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>From Date</th>
                                <th>To Date</th>
                                <th>Reason</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, String> leave : leaveRequests) { %>
                                <tr>
                                    <td><%= leave.get("leave_from") %></td>
                                    <td><%= leave.get("leave_to") %></td>
                                    <td><%= leave.get("reason").length() > 30 ? leave.get("reason").substring(0, 27) + "..." : leave.get("reason") %></td>
                                    <td>
                                        <% 
                                            String leaveStatus = leave.get("status");
                                            String badgeClass = leaveStatus.equals("Approved") ? "badge-approved" : "badge-pending";
                                        %>
                                        <span class="badge <%= badgeClass %>"><%= leaveStatus %></span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <p>No leave requests yet. <a href="leave-requests" style="color: #1a73e8; text-decoration: underline;">Submit one here</a></p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <script>
        const isClockedIn = <%= isClockedIn %>;
        const activeClockInTimeStr = <%= activeClockInTime != null ? ("\"" + activeClockInTime + "\"") : "null" %>;
        
        // Parse the server timestamp correctly
        let sessionStartTime = null;
        if (isClockedIn && activeClockInTimeStr) {
            // MySQL format: "YYYY-MM-DD HH:MM:SS" -> Convert to ISO format for proper parsing
            const normalizedTime = activeClockInTimeStr.replace(" ", "T");
            sessionStartTime = new Date(normalizedTime).getTime();
        }
        
        function updateTimer() {
            const timerDisplay = document.getElementById('timerDisplay');
            
            if (!isClockedIn || !sessionStartTime) {
                timerDisplay.textContent = '00:00:00';
                return;
            }
            
            const now = Date.now();
            const elapsed = now - sessionStartTime;
            
            const hours = Math.floor(elapsed / (1000 * 60 * 60));
            const minutes = Math.floor((elapsed % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((elapsed % (1000 * 60)) / 1000);
            
            // Format as HH:MM:SS
            const timerValue = 
                String(hours).padStart(2, '0') + ':' +
                String(minutes).padStart(2, '0') + ':' +
                String(seconds).padStart(2, '0');
            
            timerDisplay.textContent = timerValue;
        }
        
        // Update timer every second
        setInterval(updateTimer, 1000);
        
        // Initial update
        updateTimer();
    </script>
</body>
</html>
