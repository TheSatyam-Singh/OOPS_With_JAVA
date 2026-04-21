<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Leave - TimeTrack</title>
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
            gap: 20px;
        }
        
        .logo {
            font-size: 20px;
            font-weight: 600;
            color: #1a73e8;
        }
        
        .page-title {
            font-size: 16px;
            color: #202124;
            font-weight: 500;
        }
        
        .header-right {
            display: flex;
            gap: 12px;
        }
        
        .btn-header {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .btn-back {
            background-color: #f1f3f4;
            color: #1a73e8;
        }
        
        .btn-back:hover {
            background-color: #dadce0;
        }
        
        .btn-logout {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-logout:hover {
            background-color: #c82333;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 24px;
        }
        
        .page-header {
            margin-bottom: 32px;
        }
        
        .page-header h1 {
            font-size: 28px;
            font-weight: 400;
            color: #202124;
            margin-bottom: 4px;
        }
        
        .page-header p {
            font-size: 14px;
            color: #5f6368;
        }
        
        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        
        @media (max-width: 768px) {
            .grid-2 {
                grid-template-columns: 1fr;
            }
        }
        
        .card {
            background: white;
            border: 1px solid #e8eaed;
            border-radius: 8px;
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        
        .card h2 {
            font-size: 16px;
            font-weight: 500;
            color: #202124;
            margin-bottom: 20px;
            border-bottom: 1px solid #e8eaed;
            padding-bottom: 12px;
        }
        
        .form-group {
            margin-bottom: 16px;
        }
        
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #202124;
            margin-bottom: 6px;
        }
        
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #dadce0;
            border-radius: 4px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.2s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1a73e8;
            box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }
        
        .btn-submit {
            flex: 1;
            padding: 10px 16px;
            background-color: #34a853;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .btn-submit:hover {
            background-color: #2d8e47;
            box-shadow: 0 2px 6px rgba(52, 168, 83, 0.3);
        }
        
        .message {
            padding: 12px 14px;
            border-radius: 4px;
            font-size: 14px;
            margin-bottom: 16px;
            display: none;
        }
        
        .message.success {
            background-color: #d2e7d6;
            color: #0d652d;
            border-left: 4px solid #34a853;
            display: block;
        }
        
        .message.error {
            background-color: #fce5e6;
            color: #c5221f;
            border-left: 4px solid #d33b27;
            display: block;
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
            padding: 40px 20px;
            color: #5f6368;
        }
        
        .empty-icon {
            font-size: 48px;
            margin-bottom: 12px;
        }
        
        .empty-state p {
            font-size: 14px;
        }
        
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-cancel {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-cancel:hover {
            background-color: #c82333;
            box-shadow: 0 2px 4px rgba(220, 53, 69, 0.2);
        }
        
        .btn-edit {
            background-color: #1a73e8;
            color: white;
            margin-right: 6px;
        }
        
        .btn-edit:hover {
            background-color: #1557b0;
            box-shadow: 0 2px 4px rgba(26, 115, 232, 0.2);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <div class="logo">⏱ TimeTrack</div>
            <div class="page-title">Manage Leave</div>
        </div>
        <div class="header-right">
            <a href="dashboard" class="btn-header btn-back">← Back to Dashboard</a>
            <a href="logout" class="btn-header btn-logout">Sign Out</a>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="container">
        <div class="page-header">
            <h1>Leave Management</h1>
            <p>Submit new leave requests and view your leave history</p>
        </div>
        
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
                if (message.startsWith("success:")) {
                    String msg = message.substring(8);
        %>
                    <div class="message success">✓ <%= msg %></div>
        <%
                } else {
        %>
                    <div class="message error">✗ <%= message %></div>
        <%
                }
            }
        %>
        
        <div class="grid-2">
            <!-- Submit Leave Form -->
            <div class="card">
                <h2>📋 Submit Leave Request</h2>
                <form method="post" action="leave-requests">
                    <div class="form-group">
                        <label for="leaveFrom">From Date</label>
                        <input type="date" id="leaveFrom" name="leaveFrom" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="leaveTo">To Date</label>
                        <input type="date" id="leaveTo" name="leaveTo" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="reason">Reason</label>
                        <textarea id="reason" name="reason" placeholder="Enter reason for leave" required></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">Submit Request</button>
                    </div>
                </form>
            </div>
            
            <!-- Leave History -->
            <div class="card">
                <h2>📅 Leave History</h2>
                <%
                    List<Map<String, String>> leaveRequests = (List<Map<String, String>>) request.getAttribute("leaveRequests");
                    
                    if (leaveRequests != null && !leaveRequests.isEmpty()) {
                %>
                    <table>
                        <thead>
                            <tr>
                                <th>From</th>
                                <th>To</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Map<String, String> leave : leaveRequests) {
                                    String status = leave.get("status");
                                    String badgeClass = status.equals("Approved") ? "badge-approved" : "badge-pending";
                                    boolean isPending = status.equals("Pending");
                                    String leaveId = leave.get("id");
                            %>
                                <tr>
                                    <td><%= leave.get("leave_from") %></td>
                                    <td><%= leave.get("leave_to") %></td>
                                    <td><%= leave.get("reason").length() > 20 ? leave.get("reason").substring(0, 17) + "..." : leave.get("reason") %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <% if (isPending) { %>
                                            <form method="post" action="cancelleave" style="display: inline;">
                                                <input type="hidden" name="leaveId" value="<%= leaveId %>">
                                                <button type="submit" class="btn-action btn-cancel" onclick="return confirm('Cancel this leave request?')">Cancel</button>
                                            </form>
                                        <% } else { %>
                                            <span style="color: #5f6368; font-size: 12px;">-</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                <%
                    } else {
                %>
                    <div class="empty-state">
                        <div class="empty-icon">📭</div>
                        <p>No leave requests yet</p>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
