<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - TimeTrack Employee System</title>
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
        
        .login-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.12);
            width: 100%;
            max-width: 420px;
            padding: 48px 40px;
            border: 1px solid #e8eaed;
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 36px;
        }
        
        .logo {
            font-size: 36px;
            font-weight: 700;
            color: #1a73e8;
            margin-bottom: 12px;
            display: inline-block;
            letter-spacing: -0.5px;
        }
        
        h1 {
            font-size: 26px;
            color: #202124;
            margin-bottom: 6px;
            font-weight: 600;
            letter-spacing: -0.3px;
        }
        
        .subtitle {
            font-size: 14px;
            color: #5f6368;
            font-weight: 400;
        }
        
        .form-group {
            margin-bottom: 18px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 600;
            color: #202124;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #dadce0;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background-color: #fafbfc;
        }
        
        input[type="text"]:hover,
        input[type="password"]:hover {
            background-color: #f3f4f6;
            border-color: #c5c7c9;
        }
        
        input[type="text"]:focus,
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
            font-size: 13px;
            display: none;
            border-left: 4px solid;
        }
        
        .message.error {
            background-color: #fce5e6;
            color: #c5221f;
            border-left-color: #d33b27;
            display: block;
            font-weight: 500;
        }
        
        .login-btn {
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
        
        .login-btn:hover {
            background-color: #1557b0;
            box-shadow: 0 4px 12px rgba(26, 115, 232, 0.3);
            transform: translateY(-1px);
        }
        
        .login-btn:active {
            transform: translateY(0);
            box-shadow: 0 1px 3px rgba(26, 115, 232, 0.2);
        }
        
        .footer {
            text-align: center;
            margin-top: 28px;
            padding-top: 24px;
            border-top: 1px solid #e8eaed;
        }
        
        .footer-text {
            font-size: 13px;
            color: #5f6368;
            margin-bottom: 10px;
            font-weight: 400;
        }
        
        .signup-link {
            color: #1a73e8;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
        }
        
        .signup-link:hover {
            color: #1557b0;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo-section">
            <div class="logo">⏱ TimeTrack</div>
            <h1>Welcome Back</h1>
            <p class="subtitle">Employee Time Tracking System</p>
        </div>
        
        <%
            String message = (String) request.getAttribute("message");
        %>
        
        <% if (message != null) { %>
            <div class="message error"><%= message %></div>
        <% } %>
        
        <form method="post" action="login">
            <div class="form-group">
                <label for="username">Username or Email</label>
                <input type="text" id="username" name="username" placeholder="Enter your username or email" required autofocus>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>
            
            <button type="submit" class="login-btn">Sign In</button>
        </form>
        
        <div class="footer">
            <p class="footer-text">New user?</p>
            <a href="signup" class="signup-link">Create account</a>
        </div>
    </div>
    
    <script>
        // Clear old timer session when user logs in
        localStorage.removeItem('sessionStart');
    </script>
</body>
</html>
