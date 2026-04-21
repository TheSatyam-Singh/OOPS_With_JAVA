<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Clock In/Out System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            max-width: 500px;
            width: 100%;
            text-align: center;
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
        }
        
        .button-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .button-group.full {
            grid-template-columns: 1fr;
        }
        
        a {
            display: block;
            padding: 15px 25px;
            background-color: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        
        a:hover {
            background-color: #764ba2;
        }
        
        a.secondary {
            background-color: #48bb78;
        }
        
        a.secondary:hover {
            background-color: #38a169;
        }
        
        a.info {
            background-color: #4299e1;
        }
        
        a.info:hover {
            background-color: #3182ce;
        }
        
        .footer {
            margin-top: 30px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>⏰ Employee Clock In/Out System</h1>
        
        <div class="button-group">
            <a href="clockin.jsp">Clock In</a>
            <a href="clockout.jsp">Clock Out</a>
        </div>
        
        <div class="button-group">
            <a href="view" class="info">View Records</a>
            <a href="leave.jsp" class="secondary">Leave Request</a>
        </div>
        
        <div class="footer">
            <p>Employee Management System v1.0</p>
        </div>
    </div>
</body>
</html>
