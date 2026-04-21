<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Employee Clock System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .auth-container {
            background: white;
            padding: 48px 40px;
            border-radius: 12px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.12);
            max-width: 450px;
            width: 100%;
            border: 1px solid #e8eaed;
        }
        
        .auth-header {
            text-align: center;
            margin-bottom: 36px;
        }
        
        .logo {
            font-size: 36px;
            margin-bottom: 12px;
            display: inline-block;
            letter-spacing: -0.5px;
        }
        
        h1 {
            color: #202124;
            font-size: 26px;
            margin-bottom: 6px;
            font-weight: 600;
            letter-spacing: -0.3px;
        }
        
        .subtitle {
            color: #5f6368;
            font-size: 14px;
            font-weight: 400;
        }
        
        .form-group {
            margin-bottom: 18px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: #202124;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #dadce0;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #fafbfc;
            font-family: inherit;
        }
        
        input[type="text"]:hover,
        input[type="email"]:hover,
        input[type="password"]:hover {
            background-color: #f3f4f6;
            border-color: #c5c7c9;
        }
        
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #1a73e8;
            box-shadow: 0 0 0 4px rgba(26, 115, 232, 0.12);
            background-color: white;
        }
        
        .message {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 6px;
            text-align: left;
            display: none;
            font-size: 13px;
            border-left: 4px solid;
            font-weight: 500;
        }
        
        .message.error {
            background-color: #fce5e6;
            color: #c5221f;
            display: block;
            border-left-color: #d33b27;
        }
        
        .message.success {
            background-color: #d2e7d6;
            color: #0d652d;
            display: block;
            border-left-color: #34a853;
        }
        
        button {
            width: 100%;
            padding: 12px 16px;
            background-color: #1a73e8;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 12px;
            box-shadow: 0 1px 3px rgba(26, 115, 232, 0.2);
        }
        
        button:hover {
            background-color: #1557b0;
            box-shadow: 0 4px 12px rgba(26, 115, 232, 0.3);
            transform: translateY(-1px);
        }
        
        button:active {
            transform: translateY(0);
            box-shadow: 0 1px 3px rgba(26, 115, 232, 0.2);
        }
        
        .auth-footer {
            text-align: center;
            margin-top: 28px;
            padding-top: 24px;
            border-top: 1px solid #e8eaed;
        }
        
        .auth-footer p {
            color: #5f6368;
            font-size: 13px;
            font-weight: 400;
        }
        
        .auth-footer a {
            color: #1a73e8;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
        }
        
        .auth-footer a:hover {
            color: #1557b0;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-header">
            <div class="logo">⏱ TimeTrack</div>
            <h1>Create Account</h1>
            <p class="subtitle">Employee Time Tracking System</p>
        </div>
        
        <%
            String message = (String) request.getAttribute("message");
            String status = (String) request.getAttribute("status");
        %>
        
        <% if (message != null) { %>
            <div class="message <%= status != null ? status : "error" %>"><%= message %></div>
        <% } %>
        
        <form method="post" action="signup">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" placeholder="John Doe" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="john@example.com" required>
            </div>
            
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Choose a username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="At least 6 characters" required>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
            </div>
            
            <button type="submit">Create Account</button>
        </form>
        
        <div class="auth-footer">
            <p>Already have an account? <a href="login">Login here</a></p>
        </div>
    </div>
</body>
</html>
