<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Records - Employee System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #4299e1 0%, #3182ce 100%);
            min-height: 100vh;
            padding: 30px 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }
        
        h1 {
            color: #333;
            margin-bottom: 25px;
            text-align: center;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        thead {
            background-color: #4299e1;
            color: white;
        }
        
        th {
            padding: 12px;
            text-align: left;
            font-weight: bold;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        
        tbody tr:hover {
            background-color: #f7fafc;
        }
        
        tbody tr:nth-child(even) {
            background-color: #edf2f7;
        }
        
        .no-records {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 16px;
        }
        
        .back-link {
            text-align: center;
        }
        
        .back-link a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4299e1;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        
        .back-link a:hover {
            background-color: #3182ce;
        }
        
        .status-active {
            color: #f5576c;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📋 Employee Records</h1>
        
        <%
            List<Map<String, String>> records = (List<Map<String, String>>) request.getAttribute("records");
        %>
        
        <% if (records != null && !records.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Employee Name</th>
                        <th>Clock In</th>
                        <th>Clock Out</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> record : records) { %>
                        <tr>
                            <td><%= record.get("id") %></td>
                            <td><%= record.get("name") %></td>
                            <td><%= record.get("clock_in") %></td>
                            <td>
                                <% if (record.get("clock_out").equals("Still Clocked In")) { %>
                                    <span class="status-active"><%= record.get("clock_out") %></span>
                                <% } else { %>
                                    <%= record.get("clock_out") %>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="no-records">
                <p>No records found</p>
            </div>
        <% } %>
        
        <div class="back-link">
            <a href="index.jsp">← Back to Home</a>
        </div>
    </div>
</body>
</html>
