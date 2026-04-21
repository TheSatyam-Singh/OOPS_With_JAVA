<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Leave Request - Employee System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            max-width: 450px;
            width: 100%;
        }
        
        h1 {
            color: #333;
            margin-bottom: 25px;
            text-align: center;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: bold;
        }
        
        input[type="text"],
        input[type="date"],
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: Arial, sans-serif;
            transition: border-color 0.3s;
        }
        
        input[type="text"]:focus,
        input[type="date"]:focus,
        textarea:focus {
            outline: none;
            border-color: #48bb78;
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        button {
            width: 100%;
            padding: 12px;
            background-color: #48bb78;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        button:hover {
            background-color: #38a169;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
            display: none;
        }
        
        .message.success {
            background-color: #c6f6d5;
            color: #22543d;
            display: block;
        }
        
        .message.error {
            background-color: #fed7d7;
            color: #742a2a;
            display: block;
        }
        
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #48bb78;
            text-decoration: none;
            font-weight: bold;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📝 Leave Request</h1>
        
        <%
            String message = (String) request.getAttribute("message");
            String status = (String) request.getAttribute("status");
        %>
        
        <% if (message != null) { %>
            <div class="message <%= status != null ? status : "error" %>">
                <%= message %>
            </div>
        <% } %>
        
        <form method="post" action="leave">
            <div class="form-group">
                <label for="employeeName">Employee Name:</label>
                <input type="text" id="employeeName" name="employeeName" placeholder="Enter your name" required>
            </div>
            
            <div class="form-group">
                <label for="leaveDate">Leave Date:</label>
                <input type="date" id="leaveDate" name="leaveDate" required>
            </div>
            
            <div class="form-group">
                <label for="reason">Reason:</label>
                <textarea id="reason" name="reason" placeholder="Enter reason for leave" required></textarea>
            </div>
            
            <button type="submit">Submit Request</button>
        </form>
        
        <div class="back-link">
            <a href="index.jsp">← Back to Home</a>
        </div>
    </div>
</body>
</html>
