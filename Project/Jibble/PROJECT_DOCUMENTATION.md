# TimeTrack - Employee Time Tracking System

## 📋 Project Overview

**TimeTrack** is a professional Employee Time Tracking System built with Java Servlets, JSP, MySQL, and Apache Tomcat. It allows employees to:
- Clock in/out for daily work attendance
- Track work hours with automatic duration calculation
- Request and manage leave (vacation time)
- View complete attendance history
- Login with username or email

The system is styled professionally similar to **Darwinbox** and **Jibble**, with a modern UI using Google Material Design colors.

---

## 🏗️ Project Architecture

### Technology Stack
| Component | Technology | Version |
|-----------|-----------|---------|
| **Server** | Apache Tomcat | 9.0.117 |
| **Backend** | Java Servlets | javax.servlet |
| **Frontend** | JSP + HTML/CSS | ES6 JavaScript |
| **Database** | MySQL | 9.6.0 JDBC Driver |
| **JDK** | OpenJDK | 25.0.2 |
| **IDE** | IntelliJ IDEA | SmartTomcat Plugin |

### Directory Structure
```
/Users/satyamsingh/Downloads/Jibble/
├── src/com/jibble/                 # Java source files
│   ├── DBConnection.java           # Database connection manager
│   ├── LoginServlet.java           # User authentication
│   ├── SignupServlet.java          # User registration
│   ├── DashboardServlet.java       # Main dashboard data
│   ├── LogoutServlet.java          # Session cleanup
│   ├── ClockInServlet.java         # Clock-in action
│   ├── ClockOutServlet.java        # Clock-out action
│   ├── LeaveRequestsServlet.java   # Leave management page
│   ├── CancelLeaveServlet.java     # Cancel pending leaves
│   ├── EditLeaveServlet.java       # Edit pending leaves
│   ├── UpdateLeaveServlet.java     # Save leave updates
│   └── LeaveServlet.java           # Deprecated leave handler
├── WebContent/                      # JSP files & static assets
│   ├── login.jsp                   # Login page
│   ├── signup.jsp                  # Registration page
│   ├── dashboard.jsp               # Main dashboard
│   ├── leave-requests.jsp          # Leave management page
│   ├── edit-leave.jsp              # Edit leave form
│   └── WEB-INF/
│       └── web.xml                 # Servlet mappings
├── out/production/Jibble/          # Compiled .class files
├── DATABASE_SETUP.sql              # Initial database schema
└── PROJECT_DOCUMENTATION.md        # This file
```

---

## 🗄️ Database Schema

### 1. `user_accounts` Table
**Purpose:** Store employee credentials and profile information

```sql
CREATE TABLE user_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);
```

| Column | Type | Purpose |
|--------|------|---------|
| `id` | INT | Unique user identifier (Primary Key) |
| `username` | VARCHAR(50) | Login username (unique) |
| `email` | VARCHAR(100) | Email address (unique) |
| `password` | VARCHAR(100) | Encrypted password |
| `full_name` | VARCHAR(100) | Employee full name |

**Operations:**
- **CREATE** → `SignupServlet` - New user registration
- **READ** → `LoginServlet`, `DashboardServlet` - Get user data on login
- **UPDATE** → Not implemented currently
- **DELETE** → Not implemented currently

---

### 2. `attendance` Table
**Purpose:** Track daily clock-in/out records for each employee

```sql
CREATE TABLE attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    clock_in DATETIME NOT NULL,
    clock_out DATETIME,
    FOREIGN KEY (user_id) REFERENCES user_accounts(id)
);
```

| Column | Type | Purpose |
|--------|------|---------|
| `id` | INT | Unique record identifier (Primary Key) |
| `user_id` | INT | Employee ID (Foreign Key → user_accounts) |
| `clock_in` | DATETIME | When employee clocked in |
| `clock_out` | DATETIME | When employee clocked out (NULL if still clocked in) |

**Operations:**

- **CREATE** → `ClockInServlet`
  - Called when user clicks "Clock In" button
  - Inserts new row: `(user_id, NOW(), NULL)`
  - Prevents duplicate active clock-ins (checks `WHERE clock_out IS NULL`)
  
- **READ** → `DashboardServlet`
  - Fetches last 10 records: `SELECT * FROM attendance WHERE user_id = ? ORDER BY clock_in DESC LIMIT 10`
  - Fetches active clock-in: `SELECT clock_in FROM attendance WHERE user_id = ? AND clock_out IS NULL`
  
- **UPDATE** → `ClockOutServlet`
  - Updates latest active record: `UPDATE attendance SET clock_out = NOW() WHERE id = ? AND user_id = ?`
  - Finds record ID first, then updates clock_out time
  
- **DELETE** → Not implemented currently

**Key Logic:**
- `clock_out IS NULL` indicates employee is currently clocked in
- Duration calculated: `CLOCK_OUT_TIME - CLOCK_IN_TIME`
- Timer on dashboard shows real-time elapsed time from database `clock_in` timestamp

---

### 3. `leave_requests` Table
**Purpose:** Store employee leave (vacation) requests with approval status

```sql
CREATE TABLE leave_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    leave_from DATE NOT NULL,
    leave_to DATE NOT NULL,
    reason VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES user_accounts(id)
);
```

| Column | Type | Purpose |
|--------|------|---------|
| `id` | INT | Unique leave request ID (Primary Key) |
| `user_id` | INT | Employee ID (Foreign Key → user_accounts) |
| `leave_from` | DATE | Leave start date |
| `leave_to` | DATE | Leave end date |
| `reason` | VARCHAR(255) | Reason for leave (e.g., "Vacation", "Medical") |
| `status` | VARCHAR(20) | Request status: "Pending" or "Approved" |

**Operations:**

- **CREATE** → `LeaveRequestsServlet` (doPost)
  - Form submitted from leave-requests.jsp
  - Inserts: `INSERT INTO leave_requests (user_id, leave_from, leave_to, reason) VALUES (?, ?, ?, ?)`
  - Default status: "Pending"
  
- **READ** → `LeaveRequestsServlet` (doGet), `EditLeaveServlet`, `DashboardServlet`
  - Get all leaves: `SELECT * FROM leave_requests WHERE user_id = ? ORDER BY leave_from DESC`
  - Get single leave: `SELECT * FROM leave_requests WHERE id = ? AND user_id = ?`
  - Counting pending/approved: 
    ```sql
    SELECT 
        SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_count,
        SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END) AS approved_count
    FROM leave_requests WHERE user_id = ?
    ```
  
- **UPDATE** → `UpdateLeaveServlet`
  - Only for "Pending" requests
  - Updates: `UPDATE leave_requests SET leave_from = ?, leave_to = ?, reason = ? WHERE id = ? AND user_id = ?`
  - Called from edit-leave.jsp form
  
- **DELETE** → `CancelLeaveServlet`
  - Only for "Pending" requests
  - Deletes: `DELETE FROM leave_requests WHERE id = ? AND user_id = ?`
  - Cannot delete "Approved" leaves

---

## 🔐 Authentication Flow

### Login Process (LoginServlet)

```
User enters Username/Email + Password
         ↓
LoginServlet receives POST request
         ↓
Query: SELECT id, full_name, username 
       FROM user_accounts 
       WHERE (username = ? OR email = ?) AND password = ?
         ↓
Result found?
   ├─ YES → Create Session
   │         session.setAttribute("userId", id)
   │         session.setAttribute("username", username)
   │         session.setAttribute("fullName", fullName)
   │         Redirect to /dashboard
   │
   └─ NO → Show error "Invalid username/email or password"
           Forward back to login.jsp
```

**Key Features:**
- Accepts both username OR email for login
- Session-based authentication
- All servlet endpoints check: `if (session == null || session.getAttribute("userId") == null) → redirect to login`

---

## ⏱️ Clock In/Out Workflow

### Clock In (ClockInServlet)

```
User clicks "Clock In" button
         ↓
Check if already clocked in:
  Query: SELECT COUNT(*) FROM attendance 
         WHERE user_id = ? AND clock_out IS NULL
         ↓
Already clocked in?
  ├─ YES → Error: "You are already clocked in"
  │
  └─ NO → INSERT INTO attendance (user_id, clock_in) 
          VALUES (?, NOW())
          Success: "Clocked in successfully"
```

**Database State After Clock In:**
```
id | user_id | clock_in           | clock_out
10 | 1       | 2026-04-20 09:00:00| NULL      ← Active (clock_out is NULL)
```

### Clock Out (ClockOutServlet)

```
User clicks "Clock Out" button
         ↓
Find active clock-in:
  Query: SELECT id FROM attendance 
         WHERE user_id = ? AND clock_out IS NULL
         ORDER BY clock_in DESC LIMIT 1
         ↓
Found?
  ├─ YES → UPDATE attendance 
           SET clock_out = NOW() 
           WHERE id = ?
           Success: "Clocked out successfully"
  │
  └─ NO → Error: "No active clock-in found"
```

**Database State After Clock Out:**
```
id | user_id | clock_in           | clock_out
10 | 1       | 2026-04-20 09:00:00| 2026-04-20 17:30:45  ← Completed
```

### Duration Calculation (dashboard.jsp)

Frontend calculates work duration:
```javascript
clockInTime  = "2026-04-20 09:00:00"
clockOutTime = "2026-04-20 17:30:45"
elapsed      = (17 * 3600 + 30 * 60 + 45) - (9 * 3600 + 0 * 60 + 0)
             = (63045) - (32400)
             = 30645 seconds
             = 8 hours, 30 minutes, 45 seconds
```

---

## 📋 Leave Management Workflow

### Submit Leave Request

```
User fills: From Date, To Date, Reason
         ↓
LeaveRequestsServlet (POST)
         ↓
Validation:
  ✓ From date is set
  ✓ To date is set
  ✓ Reason is not empty
  ✓ Reason length ≤ 255 characters
         ↓
INSERT INTO leave_requests 
  (user_id, leave_from, leave_to, reason, status)
VALUES (1, '2026-05-01', '2026-05-05', 'Vacation', 'Pending')
         ↓
Success message displayed
```

### Edit Pending Leave

```
User clicks "✎ Edit" on Pending leave
         ↓
EditLeaveServlet (GET)
         ↓
Check status:
  Is status = 'Pending'?
  ├─ YES → Load form with current data
  │
  └─ NO → Error: "Cannot edit Approved leaves"
         ↓
User modifies dates/reason
         ↓
UpdateLeaveServlet (POST)
         ↓
Verify still Pending + belongs to user
         ↓
UPDATE leave_requests 
SET leave_from = ?, leave_to = ?, reason = ? 
WHERE id = ? AND user_id = ?
```

### Cancel Pending Leave

```
User clicks "✕ Cancel" on Pending leave
         ↓
CancelLeaveServlet (POST)
         ↓
Check status:
  Is status = 'Pending'?
  ├─ YES → DELETE FROM leave_requests WHERE id = ? AND user_id = ?
  │
  └─ NO → Error: "Cannot cancel Approved leaves"
```

---

## 📊 Dashboard Display (DashboardServlet)

The dashboard shows three main sections:

### 1. Stats Cards
```
Status Today:    Clocked In / Clocked Out
Current Timer:   HH:MM:SS (real-time)
Pending Leaves:  Count of pending requests
Approved Leaves: Count of approved requests
```

### 2. Attendance Table
Shows last 10 records with:
- Date
- Clock In time (HH:MM:SS)
- Clock Out time (HH:MM:SS or "Active")
- Duration worked (HH:MM:SS)
- Status badge (Ongoing/Completed)

**Query Used:**
```sql
SELECT id, clock_in, clock_out 
FROM attendance 
WHERE user_id = ? 
ORDER BY clock_in DESC 
LIMIT 10
```

### 3. Leave Requests Table
Shows last 10 leave requests with:
- From date
- To date
- Reason
- Status badge (Pending/Approved)
- Actions: Edit/Cancel (only for Pending)

**Query Used:**
```sql
SELECT id, leave_from, leave_to, reason, status 
FROM leave_requests 
WHERE user_id = ? 
ORDER BY leave_from DESC 
LIMIT 10
```

---

## 🔄 Servlet Request/Response Flow

### Request Flow Diagram

```
Browser Request
      ↓
web.xml URL Mapping
  /login           → LoginServlet
  /signup          → SignupServlet
  /dashboard       → DashboardServlet
  /clockin         → ClockInServlet
  /clockout        → ClockOutServlet
  /leave-requests  → LeaveRequestsServlet
  /editleave       → EditLeaveServlet
  /updateleaverequest → UpdateLeaveServlet
  /cancelleave     → CancelLeaveServlet
      ↓
Servlet Processing
  1. Check session (authentication)
  2. Get request parameters
  3. Validate input
  4. Database operation (JDBC)
  5. Set response data
      ↓
Response Handler
  ├─ Forward to JSP (for GET/display)
  └─ Redirect to another servlet (for POST/update)
```

---

## 🔌 Database Connection (DBConnection.java)

**Singleton Pattern for Connection Management:**

```java
public static Connection getConnection() {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbURL = "jdbc:mysql://localhost:3306/jibble_db";
        String user = "root";
        String password = "satyam";
        return DriverManager.getConnection(dbURL, user, password);
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
        return null;
    }
}
```

**Connection Details:**
- **Host:** localhost
- **Port:** 3306
- **Database:** jibble_db
- **User:** root
- **Password:** satyam
- **Driver:** MySQL Connector/J 9.6.0

---

## 🎨 UI/UX Design System

### Color Palette
| Color | Usage | Hex Code |
|-------|-------|----------|
| Primary Blue | Buttons, links, headers | #1a73e8 |
| Success Green | Success messages, approve | #34a853 |
| Warning Orange | Active status, warnings | #ea8600 |
| Light Gray | Background | #f8f9fa |
| Border Gray | Dividers, borders | #dadce0 |

### Typography
- **Font Family:** -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto
- **Headers:** 600 font-weight, 26-28px size
- **Labels:** 500 font-weight, 13-14px size
- **Body:** 400 font-weight, 14px size

---

## 📝 JSP Pages Overview

### login.jsp
- **Purpose:** User authentication
- **Parameters Sent:** `username` (email or username), `password`
- **Servlet Called:** `LoginServlet` (POST)
- **On Success:** Redirect to `/dashboard`
- **On Failure:** Show error message

### signup.jsp
- **Purpose:** User registration
- **Parameters Sent:** `username`, `email`, `password`, `password_confirm`, `full_name`
- **Servlet Called:** `SignupServlet` (POST)
- **Validation:** Email uniqueness, password confirmation
- **On Success:** Redirect to `/login`

### dashboard.jsp
- **Purpose:** Main employee interface
- **Timer:** Real-time clock showing elapsed time
- **Tables:** Attendance history, Leave summary
- **Buttons:** Clock In, Clock Out, Request Leave
- **Session Required:** Yes (redirects to login if not)

### leave-requests.jsp
- **Purpose:** Leave management dedicated page
- **Sections:** 
  - Submit new leave form (left)
  - Leave history table (right)
- **Actions:** Edit (for Pending), Cancel (for Pending)
- **Session Required:** Yes

### edit-leave.jsp
- **Purpose:** Modify pending leave request
- **Fields:** From Date, To Date, Reason
- **Submit To:** `UpdateLeaveServlet`
- **Validation:** All fields required, dates valid
- **Session Required:** Yes

---

## 🔒 Security Features

### 1. Session Management
- Session check on every protected servlet
- Automatic redirect to login if session invalid
- Session cleared on logout

### 2. SQL Injection Prevention
- All queries use PreparedStatements
- Parameters bound safely with `setString()`, `setInt()`, etc.
- Example:
  ```java
  String sql = "SELECT * FROM user_accounts WHERE username = ? AND password = ?";
  PreparedStatement stmt = conn.prepareStatement(sql);
  stmt.setString(1, username);  // Safe parameter binding
  stmt.setString(2, password);
  ```

### 3. Input Validation
- Empty field checks before database operations
- String length validation (e.g., reason ≤ 255 chars)
- Email format validation (in signup)
- Date validation (in leave requests)

### 4. Password Security
- Stored in plain text (⚠️ NOTE: Should be hashed with bcrypt/SHA256 in production)
- Transmitted over HTTPS recommended (set up SSL in production)

---

## 🚀 Deployment & Setup

### Prerequisites
1. **JDK 25+** installed
2. **Apache Tomcat 9.0+** downloaded
3. **MySQL 8.0+** running
4. **MySQL Connector/J 9.6.0** in classpath

### Database Setup
```sql
-- Create database
CREATE DATABASE jibble_db;
USE jibble_db;

-- Create tables (see DATABASE_SETUP.sql)
source DATABASE_SETUP.sql;

-- Insert sample data
INSERT INTO user_accounts (username, email, password, full_name) VALUES
  ('satyam', 'satyam@example.com', 'password123', 'Satyam Singh'),
  ('john123', 'john@example.com', 'pass123', 'John Doe'),
  ('jane456', 'jane@example.com', 'pass456', 'Jane Smith');
```

### Compilation
```bash
cd /Users/satyamsingh/Downloads/Jibble

javac -d out/production/Jibble \
  -cp "out/production/Jibble:
       /path/to/apache-tomcat-9.0.117/lib/servlet-api.jar:
       /path/to/apache-tomcat-9.0.117/lib/jsp-api.jar:
       /path/to/mysql-connector-j-9.6.0/mysql-connector-j-9.6.0.jar" \
  src/com/jibble/*.java
```

### Running
```bash
# Start Tomcat
/path/to/apache-tomcat-9.0.117/bin/catalina.sh start

# Access application
http://localhost:8080/Jibble/login
```

---

## 📊 Sample Data

### User 1
- **Username:** satyam
- **Email:** satyam@example.com
- **Password:** password123
- **Full Name:** Satyam Singh

### Attendance Records
```
2026-04-20 09:00:00 → 2026-04-20 17:30:00 (Duration: 8:30:00)
2026-04-19 08:45:00 → 2026-04-19 18:15:00 (Duration: 9:30:00)
2026-04-18 09:15:00 → 2026-04-18 17:00:00 (Duration: 7:45:00)
```

### Leave Requests
```
2026-05-01 to 2026-05-05 | Vacation | Pending
2026-06-10 to 2026-06-12 | Medical  | Pending
2026-07-01 to 2026-07-07 | Vacation | Approved
```

---

---

## 💻 Detailed Code Walkthrough

### 1. DBConnection.java - Database Connection Management

**Purpose:** Centralized database connection handler (Singleton Pattern)

```java
package com.jibble;
import java.sql.*;

public class DBConnection {
    // Static method - can be called without creating object
    public static Connection getConnection() {
        try {
            // Step 1: Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Step 2: Define database connection string
            String dbURL = "jdbc:mysql://localhost:3306/jibble_db";
            String user = "root";
            String password = "satyam";
            
            // Step 3: Create and return connection
            return DriverManager.getConnection(dbURL, user, password);
            
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found!");
            e.printStackTrace();
            return null;
        } catch (SQLException e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
            return null;
        }
    }
}
```

**Why this approach?**
- ✅ **Reusability:** All servlets call `DBConnection.getConnection()` instead of duplicating code
- ✅ **Maintainability:** If credentials change, update only one place
- ✅ **Error Handling:** Catches both driver and SQL exceptions
- ✅ **Static Method:** No need to create object instance

**Connection String Breakdown:**
```
jdbc:mysql://localhost:3306/jibble_db
  ↑      ↑    ↑         ↑     ↑
  |      |    |         |     └─ Database name
  |      |    |         └─ Port number (default MySQL)
  |      |    └─ Server address (localhost = this computer)
  |      └─ Protocol (mysql)
  └─ JDBC (Java Database Connectivity)
```

---

### 2. LoginServlet.java - User Authentication

**Purpose:** Authenticate users with username OR email

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // Step 1: Get form parameters
    String usernameOrEmail = request.getParameter("username").trim();
    String password = request.getParameter("password").trim();
    String message = "";
    
    // Step 2: Validate input
    if (usernameOrEmail.isEmpty() || password.isEmpty()) {
        message = "Username/Email and password required";
        request.setAttribute("message", message);
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);  // Show error on same page
        return;
    }
    
    try {
        // Step 3: Get database connection
        Connection conn = DBConnection.getConnection();
        
        // Step 4: Prepare SQL query with BOTH username and email checks
        String sql = "SELECT id, full_name, username FROM user_accounts " +
                     "WHERE (username = ? OR email = ?) AND password = ?";
        
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, usernameOrEmail);  // Check as username
        stmt.setString(2, usernameOrEmail);  // OR check as email
        stmt.setString(3, password);
        
        // Step 5: Execute query
        ResultSet rs = stmt.executeQuery();
        
        // Step 6: Check if user found
        if (rs.next()) {
            // User exists - create session
            HttpSession session = request.getSession();
            session.setAttribute("userId", rs.getInt("id"));
            session.setAttribute("username", rs.getString("username"));
            session.setAttribute("fullName", rs.getString("full_name"));
            
            // Redirect to dashboard (only happens if login successful)
            response.sendRedirect("dashboard");
        } else {
            // User not found - show error
            message = "Invalid username/email or password";
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
        
        // Step 7: Clean up resources
        rs.close();
        stmt.close();
        conn.close();
        
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        request.setAttribute("message", message);
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }
}
```

**Key Security Features:**
- ✅ **PreparedStatement:** Prevents SQL injection attacks
- ✅ **OR condition:** Accepts both username and email
- ✅ **Session-based:** User ID stored in session (not in cookies)
- ✅ **Error handling:** Database errors caught and displayed
- ✅ **Input trimming:** `trim()` removes extra spaces

**Security Note:** Password is stored in plain text (⚠️ BAD PRACTICE - should use bcrypt/SHA256)

---

### 3. ClockInServlet.java - Prevent Duplicate Clock-Ins

**Purpose:** Allow only ONE active clock-in at a time

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login");
        return;
    }
    
    Integer userId = (Integer) session.getAttribute("userId");
    String message = "";
    
    try {
        Connection conn = DBConnection.getConnection();
        
        // STEP 1: Check if user already has an active clock-in
        String checkSql = "SELECT id FROM attendance " +
                         "WHERE user_id = ? AND clock_out IS NULL";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setInt(1, userId);
        ResultSet checkRs = checkStmt.executeQuery();
        
        // If result found = already clocked in
        if (checkRs.next()) {
            message = "You are already clocked in. Please clock out before clocking in again.";
        } else {
            // STEP 2: No active clock-in, so proceed with inserting new one
            String insertSql = "INSERT INTO attendance (user_id, clock_in) VALUES (?, NOW())";
            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setInt(1, userId);
            
            int result = insertStmt.executeUpdate();  // Returns 1 if successful
            
            if (result > 0) {
                message = "success:Clock-in successful!";
            } else {
                message = "Failed to clock in";
            }
            insertStmt.close();
        }
        
        checkRs.close();
        checkStmt.close();
        conn.close();
        
    } catch (SQLException e) {
        message = "Database error: " + e.getMessage();
        e.printStackTrace();
    }
    
    session.setAttribute("message", message);
    response.sendRedirect("dashboard");
}
```

**SQL Query Explanation:**
```sql
-- Check for active clock-in
WHERE user_id = ? AND clock_out IS NULL
  ↑              ↑ ↑ ↑
  |              | | └─ NULL means no clock-out yet (ACTIVE)
  |              | └─ AND (both conditions must be true)
  |              └─ Specific user
  └─ Only this user's records
```

**Why `clock_out IS NULL`?**
- When clocking in: `(user_id, clock_in=NOW(), clock_out=NULL)`
- When clocking out: `(user_id, clock_in=..., clock_out=NOW())`
- If `clock_out IS NULL` → user is currently clocked in
- If `clock_out IS NOT NULL` → user already clocked out

---

### 4. DashboardServlet.java - Fetch Timer Data

**Purpose:** Calculate active clock-in time for real-time timer

```java
// Find if user is currently clocked in
String activeAttendanceSql = 
    "SELECT clock_in FROM attendance " +
    "WHERE user_id = ? AND clock_out IS NULL " +
    "ORDER BY clock_in DESC LIMIT 1";

PreparedStatement activeAttendanceStmt = conn.prepareStatement(activeAttendanceSql);
activeAttendanceStmt.setInt(1, userId);
ResultSet activeAttendanceRs = activeAttendanceStmt.executeQuery();

// Check result
if (activeAttendanceRs.next()) {
    // User is clocked in
    Timestamp activeClockIn = activeAttendanceRs.getTimestamp("clock_in");
    isClockedIn = true;
    activeClockInTime = activeClockIn != null ? activeClockIn.toString() : null;
    // Result: "2026-04-20 09:00:00"
}

// Pass to JSP
request.setAttribute("isClockedIn", isClockedIn);
request.setAttribute("activeClockInTime", activeClockInTime);
```

**What happens in dashboard.jsp:**
```javascript
const isClockedIn = <%= isClockedIn %>;           // true or false
const activeClockInTimeStr = <%= activeClockInTime %>;  // "2026-04-20 09:00:00"

// Convert to JavaScript Date
let sessionStartTime = null;
if (isClockedIn && activeClockInTimeStr) {
    const normalizedTime = activeClockInTimeStr.replace(" ", "T");
    // "2026-04-20 09:00:00" → "2026-04-20T09:00:00"
    sessionStartTime = new Date(normalizedTime).getTime();
    // Result: milliseconds since Jan 1, 1970
}

// Update timer every second
setInterval(() => {
    const now = Date.now();
    const elapsed = now - sessionStartTime;  // Milliseconds elapsed
    
    // Convert to HH:MM:SS
    const hours = Math.floor(elapsed / 3600000);
    const minutes = Math.floor((elapsed % 3600000) / 60000);
    const seconds = Math.floor((elapsed % 60000) / 1000);
    
    const timerValue = `${hours}:${minutes}:${seconds}`;
    // Result: "8:45:30"
}, 1000);  // Run every 1000ms (1 second)
```

---

### 5. ClockOutServlet.java - Update Clock-Out Time

**Purpose:** Record when employee leaves work

```java
try {
    Connection conn = DBConnection.getConnection();
    
    // STEP 1: Find the active clock-in record ID
    String getIdSql = "SELECT id FROM attendance " +
                      "WHERE user_id = ? AND clock_out IS NULL " +
                      "ORDER BY clock_in DESC LIMIT 1";
    PreparedStatement getIdStmt = conn.prepareStatement(getIdSql);
    getIdStmt.setInt(1, userId);
    ResultSet rs = getIdStmt.executeQuery();
    
    int recordId = -1;
    if (rs.next()) {
        recordId = rs.getInt("id");  // Get the record's unique ID
    }
    rs.close();
    getIdStmt.close();
    
    // STEP 2: Update that specific record with clock-out time
    int result = 0;
    if (recordId > 0) {
        String sql = "UPDATE attendance SET clock_out = NOW() WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, recordId);  // Use the ID we found above
        result = stmt.executeUpdate();  // Returns 1 if update successful
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
}
```

**Why find ID first, then update?**

❌ **This would FAIL (doesn't work in MySQL UPDATE):**
```sql
UPDATE attendance SET clock_out = NOW() 
WHERE user_id = 1 AND clock_out IS NULL 
ORDER BY clock_in DESC LIMIT 1
```
ERROR: You can't use ORDER BY in UPDATE statement!

✅ **So we do it in TWO steps:**
```java
// Step 1: SELECT to find the ID
SELECT id FROM attendance WHERE user_id = 1 AND clock_out IS NULL 
ORDER BY clock_in DESC LIMIT 1
// Returns: id = 42

// Step 2: UPDATE using that ID
UPDATE attendance SET clock_out = NOW() WHERE id = 42
// SUCCESS!
```

---

### 6. LeaveRequestsServlet.java - Handle Leave Requests

**Purpose:** Submit new leave requests with date range

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    
    Integer userId = (Integer) session.getAttribute("userId");
    String leaveFrom = request.getParameter("leaveFrom");      // "2026-05-01"
    String leaveTo = request.getParameter("leaveTo");          // "2026-05-05"
    String reason = request.getParameter("reason").trim();     // "Vacation"
    String message = "";
    
    // VALIDATION STEP 1: Check all fields are provided
    if (leaveFrom == null || leaveFrom.isEmpty()) {
        message = "Please select 'From' date";
    } else if (leaveTo == null || leaveTo.isEmpty()) {
        message = "Please select 'To' date";
    } else if (reason == null || reason.isEmpty()) {
        message = "Please enter reason";
    } else if (reason.length() > 255) {
        message = "Reason must be less than 255 characters";
    } else {
        // VALIDATION PASSED - Insert into database
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql = "INSERT INTO leave_requests " +
                        "(user_id, leave_from, leave_to, reason) " +
                        "VALUES (?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);           // User ID
            stmt.setString(2, leaveFrom);     // "2026-05-01"
            stmt.setString(3, leaveTo);       // "2026-05-05"
            stmt.setString(4, reason);        // "Vacation"
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                message = "success:Leave request submitted successfully!";
            } else {
                message = "Failed to submit leave request";
            }
            
            stmt.close();
            conn.close();
            
        } catch (SQLException e) {
            message = "Database error: " + e.getMessage();
        }
    }
    
    // Set message in session (will be displayed on redirect)
    request.getSession().setAttribute("message", message);
    response.sendRedirect("leave-requests");  // Redirect to refresh page
}
```

**Message Formatting:**
```
message starts with "success:" → Green success message
message is anything else        → Red error message

In JSP:
<% if (message.startsWith("success:")) { %>
    <div class="message success">✓ <%= message.substring(8) %></div>
    <!-- substring(8) removes "success:" prefix -->
<% } %>
```

---

### 7. UpdateLeaveServlet.java - Edit Pending Leaves

**Purpose:** Allow users to modify leave requests that are still Pending

```java
// STEP 1: Verify the leave is still in "Pending" status
String checkSql = "SELECT status FROM leave_requests WHERE id = ? AND user_id = ?";
PreparedStatement checkStmt = conn.prepareStatement(checkSql);
checkStmt.setInt(1, leaveId);      // Which leave?
checkStmt.setInt(2, userId);       // Belongs to this user?
ResultSet rs = checkStmt.executeQuery();

if (rs.next()) {
    String status = rs.getString("status");
    
    if ("Pending".equals(status)) {
        // STEP 2: Status is Pending - allow update
        String sql = "UPDATE leave_requests " +
                    "SET leave_from = ?, leave_to = ?, reason = ? " +
                    "WHERE id = ? AND user_id = ?";
        
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, leaveFrom);      // New from date
        stmt.setString(2, leaveTo);        // New to date
        stmt.setString(3, reason);         // New reason
        stmt.setInt(4, leaveId);           // Which record?
        stmt.setInt(5, userId);            // Verify ownership
        
        int result = stmt.executeUpdate();
        if (result > 0) {
            message = "success:Leave request updated successfully!";
        }
    } else {
        // Status is Approved or Rejected - cannot modify
        message = "Cannot edit " + status + " leave requests";
    }
}
```

**Security Check:**
```java
WHERE id = ? AND user_id = ?
```
This ensures:
- ✅ Only the SPECIFIC leave (by ID)
- ✅ Owned by the CURRENT USER (not someone else's leave)
- ✅ Prevents unauthorized modifications

---

### 8. CancelLeaveServlet.java - Delete Pending Leaves

**Purpose:** Allow users to cancel leave requests that haven't been approved

```java
// STEP 1: Check if leave is Pending and belongs to user
String checkSql = "SELECT status FROM leave_requests WHERE id = ? AND user_id = ?";
// ... execute check ...

if ("Pending".equals(status)) {
    // STEP 2: Delete the leave request
    String deleteSql = "DELETE FROM leave_requests WHERE id = ? AND user_id = ?";
    PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
    deleteStmt.setInt(1, leaveId);
    deleteStmt.setInt(2, userId);
    
    int result = deleteStmt.executeUpdate();  // Returns 1 if deleted
    
    if (result > 0) {
        message = "success:Leave request canceled successfully!";
    }
} else {
    // Cannot cancel Approved leaves
    message = "Cannot cancel " + status + " leave requests";
}
```

**Why can't delete Approved leaves?**
- Approved leaves are confirmed with admin/manager
- Changing them could disrupt work planning
- Should require approval to cancel

---

## 🎓 Assessment Preparation Questions & Answers

### Q1: Why use PreparedStatement instead of concatenating SQL?

**Bad Way (Vulnerable):**
```java
String sql = "SELECT * FROM user_accounts WHERE username = '" + username + "'";
// If username = "' OR '1'='1" → Entire table exposed!
```

**Good Way (Safe):**
```java
String sql = "SELECT * FROM user_accounts WHERE username = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, username);  // Input treated as DATA, not code
```

✅ **PreparedStatement benefits:**
- Prevents SQL injection
- Treats user input as DATA only
- Separates code from data
- More efficient (query plan cached)

---

### Q2: How does the timer persist across page reloads?

**Problem:** If user closes browser while clocked in, timer should continue from original clock-in time.

**Solution:** Timer uses DATABASE timestamp, not browser time.

```javascript
// Wrong approach (loses time on page refresh):
let elapsed = localStorage.getItem('elapsedTime');  // Will be wrong!

// Right approach (uses actual clock-in from database):
const activeClockInTime = "2026-04-20 09:00:00";  // From DashboardServlet
const sessionStartTime = new Date(activeClockInTime).getTime();
const now = Date.now();
const elapsed = now - sessionStartTime;  // Always correct!
```

Flow:
```
Morning 9:00 AM → Clock In → Database: clock_in = 2026-04-20 09:00:00
       ↓
Close browser
       ↓
Evening 5:00 PM → Open browser → DashboardServlet fetches clock_in = 2026-04-20 09:00:00
       ↓
Timer calculates: 5:00 PM - 9:00 AM = 8 hours
       ↓
Displays correctly: "08:00:00"
```

---

### Q3: What does `ORDER BY clock_in DESC LIMIT 1` do?

```sql
SELECT * FROM attendance WHERE user_id = 1 ORDER BY clock_in DESC LIMIT 1
```

Breakdown:
- `ORDER BY clock_in DESC` = Sort by clock_in DESCENDING (newest first)
- `LIMIT 1` = Return only 1 row (the newest one)

**Use case:** Get the most recent clock-in time
```
Attendance records for user 1:
┌─────────────────────┬────────────┐
│ clock_in            │ clock_out  │
├─────────────────────┼────────────┤
│ 2026-04-20 09:00:00 │ NULL       │ ← Newest (DESC sort picks this)
│ 2026-04-19 08:45:00 │ 18:00:00   │
│ 2026-04-18 09:15:00 │ 17:30:00   │
└─────────────────────┴────────────┘

LIMIT 1 returns only the first row (most recent)
```

---

### Q4: Why is HttpSession used instead of cookies for storing user ID?

**Cookies:**
```
❌ Sent to browser (security risk)
❌ Client can modify them
❌ Limited size (4KB)
```

**Session (Server-side):**
```
✅ Stored on server only
✅ Client only gets session ID (random token)
✅ Can store large objects
✅ Secure and tamper-proof

Example:
1. User logs in successfully
2. Server creates session with unique ID: "abc123def456"
3. Server stores: sessions["abc123def456"] = {userId: 1, username: "satyam", ...}
4. Server sends to browser: "Set-Cookie: JSESSIONID=abc123def456"
5. Browser sends back JSESSIONID in every request
6. Server looks up session using that ID
7. Gets user data from session (never exposed to client)
```

---

### Q5: How does the form prevent double submission?

**Problem:** User clicks "Submit" twice quickly → Form submitted twice → Duplicate database entry

**Solution:** Redirect after POST

```java
// In servlet:
int result = stmt.executeUpdate();
if (result > 0) {
    message = "success:...";
}
request.getSession().setAttribute("message", message);
response.sendRedirect("leave-requests");  // ← KEY: Redirect!
```

Flow:
```
User clicks "Submit Leave"
         ↓
POST request goes to LeaveRequestsServlet
         ↓
Servlet inserts into database
         ↓
Servlet calls response.sendRedirect("leave-requests")
         ↓
Browser receives redirect response (302 Found)
         ↓
Browser automatically sends GET request to leave-requests
         ↓
LeaveRequestsServlet.doGet() handles it (displays page)
         ↓
URL in address bar changes to /leave-requests

If user clicks "Submit" again:
- It sends another GET request (not POST)
- Browser doesn't re-submit the form
- No duplicate database entry!

Pattern: POST-Redirect-GET (PRG)
```

---

### Q6: What happens if two employees try to clock in simultaneously?

**Scenario:**
```
Employee 1: Clock in
Employee 2: Clock in
(Both at exact same millisecond)
```

**Database handles it:**
- MySQL automatically assigns unique `id` to each record
- Each INSERT creates separate row with own ID
- No conflict (primary key ensures uniqueness)

```sql
-- Simultaneous inserts:
INSERT INTO attendance (user_id, clock_in) VALUES (1, NOW());  -- Employee 1
INSERT INTO attendance (user_id, clock_in) VALUES (2, NOW());  -- Employee 2

-- Both succeed because:
-- id will be: 101, 102 (auto-increment)
-- user_id is different (1 vs 2)
```

---

### Q7: How to prevent one user from accessing another user's leave?

**In EditLeaveServlet:**
```java
String sql = "SELECT * FROM leave_requests WHERE id = ? AND user_id = ?";
//                                                      ↑    ↑
//                                                      |    └─ Current user's ID
//                                                      └─ Requested leave ID

stmt.setInt(1, leaveId);      // Requested leave
stmt.setInt(2, userId);       // Current user's ID
```

Example:
```
User 1 tries to edit leave ID 5:
SELECT * FROM leave_requests WHERE id = 5 AND user_id = 1
├─ id = 5 exists?
└─ user_id = 1?
   ├─ YES → Allowed to edit
   └─ NO → No results (appears not found)

User 2 tries to edit leave ID 5:
SELECT * FROM leave_requests WHERE id = 5 AND user_id = 2
├─ id = 5 exists?
└─ user_id = 2? (NO! It belongs to user 1)
   └─ No results returned (denied access)
```

---

### Q8: What's the purpose of `RequestDispatcher.forward()`?

**Forward:** Server-side redirect (URL doesn't change in browser)
```java
RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
dispatcher.forward(request, response);

Browser sees: http://localhost:8080/Jibble/login
Server shows: login.jsp content
(URL unchanged)
```

**Used for:**
- ✅ Displaying error messages on same page
- ✅ Forward to JSP after validation failure
- ✅ Sharing request data with JSP

**vs Redirect:** Browser-side redirect (URL changes)
```java
response.sendRedirect("dashboard");

Browser sees: http://localhost:8080/Jibble/dashboard
(URL changed in address bar)
```

**Used for:**
- ✅ After successful POST (PRG pattern)
- ✅ Redirecting to different pages
- ✅ Preventing form resubmission

---

### Q9: How does duration calculation work?

**In database:**
```
clock_in:  2026-04-20 09:00:00
clock_out: 2026-04-20 17:30:45
Duration:  8 hours 30 minutes 45 seconds
```

**In dashboard.jsp (JSP calculation):**
```java
<%
    String clockInTime = "2026-04-20 09:00:00";
    String clockOutTime = "2026-04-20 17:30:45";
    String[] inParts = clockInTime.split(":");
    String[] outParts = clockOutTime.split(":");
    
    // Convert to seconds:
    // 09:00:00 → 9*3600 + 0*60 + 0 = 32400 seconds
    // 17:30:45 → 17*3600 + 30*60 + 45 = 63045 seconds
    
    int inSecs = 32400;
    int outSecs = 63045;
    int durationSecs = outSecs - inSecs;  // 30645 seconds
    
    // Convert back to HH:MM:SS:
    // hours = 30645 / 3600 = 8
    // minutes = (30645 % 3600) / 60 = 2445 / 60 = 30
    // seconds = 30645 % 60 = 45
    // Result: 08:30:45
%>
```

---

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Kill process on port 8080
lsof -i :8080
kill -9 <PID>

# Kill process on port 8005
lsof -i :8005
kill -9 <PID>
```

### Database Connection Failed
- Verify MySQL is running: `brew services list`
- Check credentials in `DBConnection.java`
- Verify database exists: `mysql -u root -p jibble_db`

### Servlet Not Found (404)
- Check `web.xml` for correct URL mappings
- Ensure servlet class is compiled in `out/production/Jibble`
- Clear Tomcat work directory: `rm -rf ~/.SmartTomcat/Jibble/Jibble/work`

### Timer Not Updating
- Refresh browser (JavaScript is client-side)
- Check browser console for errors
- Verify `activeClockInTime` is passed from `DashboardServlet`

### Multiple Clock-Ins Error
- Check database: `SELECT * FROM attendance WHERE user_id = 1 AND clock_out IS NULL`
- If multiple rows with NULL clock_out, manually fix: `UPDATE attendance SET clock_out = NOW() WHERE ...`

### Leave Edit Not Working
- Verify leave status is "Pending": `SELECT status FROM leave_requests WHERE id = 5`
- Check user_id matches: `SELECT * FROM leave_requests WHERE id = 5 AND user_id = 1`
- Ensure servlet is compiled: `ls -la out/production/Jibble/com/jibble/UpdateLeaveServlet.class`

---

## 🎓 Interview Questions & Model Answers

### Q1: Tell us about your TimeTrack project

**Model Answer:**
"TimeTrack is an employee time tracking system built with Java Servlets, JSP, MySQL, and Apache Tomcat. It has three main features:

1. **Authentication**: Users can log in with username or email
2. **Attendance Tracking**: Employees clock in/out, system calculates work duration
3. **Leave Management**: Employees can submit, edit, and cancel leave requests

The project uses:
- **Backend**: Java Servlets for business logic
- **Database**: MySQL for persistent storage (3 tables)
- **Frontend**: JSP and JavaScript for UI
- **Security**: PreparedStatements to prevent SQL injection, sessions for authentication

Key features:
- Prevents duplicate clock-ins
- Real-time timer that persists across page reloads
- Professional Darwinbox-style UI
- Full CRUD operations on attendance and leave requests"

---

### Q2: How did you ensure the timer persists across page reloads?

**Model Answer:**
"The timer persistence was achieved by using server-side database timestamps instead of browser-side storage:

1. **DashboardServlet** queries the database for active clock-in:
   ```sql
   SELECT clock_in FROM attendance 
   WHERE user_id = ? AND clock_out IS NULL
   ```

2. **Passes the timestamp to JSP** as `activeClockInTime` variable

3. **JavaScript converts to milliseconds** and calculates elapsed time from the database timestamp (not from page load):
   ```javascript
   const elapsed = Date.now() - databaseClockInTime;
   ```

4. **Updates every second** to show real-time elapsed time

This way:
- ✅ If user closes browser at 9:30 AM and reopens at 5:00 PM
- ✅ Timer still shows correct time from 9:00 AM start
- ✅ Not affected by local computer time"

---

### Q3: How did you prevent SQL injection?

**Model Answer:**
"I used **PreparedStatements** for all database queries:

```java
String sql = "SELECT * FROM user_accounts WHERE username = ?";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, username);  // Input is treated as DATA
```

Why this is secure:
- The SQL query structure is fixed (? is a placeholder)
- User input is bound separately as data
- Even if user enters: `' OR '1'='1`, it's treated as a string literal
- The database receives: `SELECT * FROM user_accounts WHERE username = '' OR '1'='1'`
  But it's interpreted as: username equals the string `' OR '1'='1'` (not as code)

I avoided:
```java
// ❌ WRONG - Vulnerable to SQL injection
String sql = "SELECT * FROM user_accounts WHERE username = '" + username + "'";
```

This approach also improves performance because the query plan is cached."

---

### Q4: How did you prevent duplicate clock-ins?

**Model Answer:**
"Before inserting a new clock-in, I check if user already has an active clock-in:

```java
String checkSql = "SELECT id FROM attendance WHERE user_id = ? AND clock_out IS NULL";
// clock_out IS NULL means not clocked out yet (ACTIVE)

if (resultSet.next()) {
    // User already clocked in - show error
    message = "You are already clocked in";
} else {
    // No active clock-in - proceed with insert
    INSERT INTO attendance (user_id, clock_in) VALUES (?, NOW());
}
```

This ensures:
- ✅ Only ONE active clock-in per user at a time
- ✅ Prevents time tracking errors
- ✅ Automatically enforces business logic at database level"

---

### Q5: Why use session storage instead of cookies for user ID?

**Model Answer:**
"Sessions are more secure for storing user IDs:

| Aspect | Cookie | Session |
|--------|--------|---------|
| Storage | Browser (client-side) | Server (server-side) |
| Risk | User can modify it | Cannot be modified by user |
| Size | Limited (4KB) | No limit |
| Data | All sent to server | Only ID sent |
| Security | Less secure | More secure |

**Example flow:**
1. User logs in → Server verifies credentials
2. Server creates Session object and stores user data
3. Server generates random session ID: `abc123def456xyz`
4. Browser gets cookie: `JSESSIONID=abc123def456xyz`
5. For each request, browser sends session ID
6. Server looks up session using that ID
7. User data never exposed to browser

If I used cookies:
- ❌ User could edit: `userId=1` to `userId=2`
- ❌ Access another user's data
- ❌ No protection against tampering"

---

### Q6: Describe the request flow from user clicking "Clock In"

**Model Answer:**
"Complete request flow:

```
1. Browser: User clicks <button>Clock In</button>
         ↓
2. HTML: <form method='post' action='clockin'>
         ↓
3. Server receives: POST /Jibble/clockin
         ↓
4. web.xml maps: /clockin → ClockInServlet
         ↓
5. Java: doPost() method executes
         ↓
6. Check session: if (session == null) redirect to login
         ↓
7. Get userId from session
         ↓
8. Query database:
   SELECT id FROM attendance 
   WHERE user_id = ? AND clock_out IS NULL
         ↓
9. If result found: Show error 'Already clocked in'
   If not found: 
         ↓
10. INSERT INTO attendance (user_id, clock_in) VALUES (?, NOW())
         ↓
11. Set message in session: 'success:Clock in successful'
         ↓
12. response.sendRedirect('dashboard')
         ↓
13. Browser receives 302 Found redirect response
         ↓
14. Browser automatically GET /Jibble/dashboard
         ↓
15. DashboardServlet fetches attendance data
         ↓
16. JSP renders dashboard.jsp with data
         ↓
17. Success message displayed to user
```

This follows the **PRG pattern** (Post-Redirect-Get):
- POST processes form (changes database)
- Redirect to prevent form resubmission
- GET displays result"

---

### Q7: How would you scale this system to 1000 employees?

**Model Answer:**
"Current limitations and solutions:

1. **Database Performance:**
   - ❌ Current: SELECT with LIMIT 10 per user
   - ✅ Solution: Add indexes on user_id, clock_in columns
   ```sql
   CREATE INDEX idx_attendance_user_id_clockout 
   ON attendance(user_id, clock_out);
   CREATE INDEX idx_leave_user_id_status 
   ON leave_requests(user_id, status);
   ```

2. **Connection Pool:**
   - ❌ Current: New connection per request
   - ✅ Solution: Use HikariCP connection pooling
   ```java
   HikariConfig config = new HikariConfig();
   config.setMaximumPoolSize(20);
   HikariDataSource ds = new HikariDataSource(config);
   ```

3. **Caching:**
   - ❌ Current: Query database for every dashboard load
   - ✅ Solution: Cache user data (Redis)
   ```java
   String cachedUserData = redis.get("user:" + userId);
   if (cachedUserData == null) {
       cachedUserData = queryDatabase();
       redis.set("user:" + userId, cachedUserData, 300); // 5 min expiry
   }
   ```

4. **Database Optimization:**
   - ✅ Archive old attendance records
   - ✅ Partition tables by user_id
   - ✅ Use read replicas for reporting

5. **Architecture:**
   - ✅ Load balancer across multiple Tomcat instances
   - ✅ Separate database server
   - ✅ Message queue for async operations"

---

### Q8: What security vulnerabilities exist and how to fix them?

**Model Answer:**
"Current vulnerabilities and fixes:

1. **Plaintext Passwords:**
   - ❌ Problem: Passwords stored as plain text
   - ✅ Fix: Use bcrypt hashing
   ```java
   // Signup:
   String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
   
   // Login:
   if (BCrypt.checkpw(password, storedHash)) { success }
   ```

2. **No HTTPS:**
   - ❌ Problem: Credentials sent over HTTP
   - ✅ Fix: Enable SSL/TLS in Tomcat
   ```xml
   <Connector port=\"8443\" protocol=\"org.apache.coyote.http11.Http11NioProtocol\"
              scheme=\"https\" secure=\"true\" 
              keystore.../>
   ```

3. **No CSRF Protection:**
   - ❌ Problem: Cross-site request forgery possible
   - ✅ Fix: Add CSRF tokens
   ```jsp
   <%
       String token = java.util.UUID.randomUUID().toString();
       session.setAttribute(\"csrfToken\", token);
   %>
   <input type=\"hidden\" name=\"csrfToken\" value=\"<%= token %>\">
   ```

4. **No Input Validation:**
   - ❌ Problem: XSS attacks possible
   - ✅ Fix: Escape HTML output
   ```jsp
   <%= StringEscapeUtils.escapeHtml4(reason) %>
   ```

5. **No Rate Limiting:**
   - ❌ Problem: Brute force attacks possible
   - ✅ Fix: Implement rate limiting
   ```java
   if (failedAttempts > 5) {
       lockAccount(username);
   }
   ```"

---

## 📚 Concepts You Should Know

### 1. MVC Architecture
- **Model**: Database (MySQL)
- **View**: JSP pages (UI)
- **Controller**: Servlets (business logic)

### 2. Request/Response Cycle
```
Browser ←→ Web Server (Tomcat) ←→ Servlet ←→ Database
  ↓              ↓                   ↓          ↓
Request      Receives         Processes      Queries
  ↓              ↓                   ↓          ↓
Response     Executes           Returns       Response
```

### 3. HTTP Methods
- **GET**: Retrieve data (safe, idempotent)
- **POST**: Submit data (changes server state)

### 4. SQL CRUD Operations
- **CREATE**: INSERT
- **READ**: SELECT
- **UPDATE**: UPDATE
- **DELETE**: DELETE

### 5. ACID Properties (Database)
- **Atomicity**: All or nothing
- **Consistency**: Valid state
- **Isolation**: No interference
- **Durability**: Persistent

---

## 🔍 Code Review Checklist

### Before Submitting Code

- [ ] All SQL queries use PreparedStatement
- [ ] Session validation on all protected servlets
- [ ] Input validation before database operations
- [ ] Proper error handling with try-catch
- [ ] Resources closed (rs.close(), stmt.close(), conn.close())
- [ ] No hardcoded passwords/credentials
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] PRG pattern used for form submissions
- [ ] Consistent error messages
- [ ] Professional UI/UX
- [ ] Code comments for complex logic
- [ ] Consistent naming conventions
- [ ] No dead code or commented code
- [ ] Tomcat configured correctly
- [ ] Database connected and verified
- [ ] All servlets compiled successfully
- [ ] web.xml mappings correct

---

## 📊 Performance Tips

### 1. Database Queries
```java
// ❌ SLOW: Query for each row
for (Map<String, String> leave : leaveRequests) {
    Statement stmt = conn.createStatement();
    stmt.execute("SELECT * FROM leave_requests WHERE id = " + leave.get("id"));
}

// ✅ FAST: Single query for all rows
String sql = "SELECT * FROM leave_requests WHERE user_id = ?";
```

### 2. Connection Pooling
```java
// ❌ SLOW: New connection per request
Connection conn = DriverManager.getConnection(url, user, pass);

// ✅ FAST: Connection pool
HikariDataSource pool = new HikariDataSource(config);
Connection conn = pool.getConnection();
```

### 3. Indexing
```sql
-- ❌ SLOW: Full table scan
SELECT * FROM attendance WHERE user_id = 1;

-- ✅ FAST: Index lookup
CREATE INDEX idx_user_id ON attendance(user_id);
SELECT * FROM attendance WHERE user_id = 1;
```

### 4. Caching
```java
// ❌ SLOW: Query every time
String name = db.query("SELECT full_name FROM user_accounts WHERE id = " + userId);

// ✅ FAST: Cache in session
String name = (String) session.getAttribute("fullName");
```

---

## 🎯 What Interviewers Look For

### Technical Competency
- ✅ Understanding of servlets and JSP lifecycle
- ✅ SQL knowledge and query optimization
- ✅ Security best practices
- ✅ MVC architecture understanding
- ✅ Error handling and logging

### Problem-Solving
- ✅ Can identify and fix bugs
- ✅ Thinks about edge cases
- ✅ Proposes optimizations
- ✅ Explains trade-offs

### Code Quality
- ✅ Clean, readable code
- ✅ Proper naming conventions
- ✅ Comments for complex logic
- ✅ Follows design patterns
- ✅ DRY principle (Don't Repeat Yourself)

### Communication
- ✅ Can explain code clearly
- ✅ Discusses design decisions
- ✅ Asks clarifying questions
- ✅ Listens to feedback

---

## 📝 Common Mistakes to Avoid

### 1. Not Closing Resources
```java
// ❌ WRONG: Leak memory
Connection conn = DBConnection.getConnection();
ResultSet rs = stmt.executeQuery();
// No close() - connection never released!

// ✅ CORRECT
try {
    ResultSet rs = stmt.executeQuery();
} finally {
    rs.close();
    stmt.close();
    conn.close();
}
```

### 2. No Session Check
```java
// ❌ WRONG: No authentication
Integer userId = (Integer) request.getSession().getAttribute("userId");
// What if session doesn't exist?

// ✅ CORRECT
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("userId") == null) {
    response.sendRedirect("login");
    return;
}
```

### 3. Using SELECT * 
```java
// ❌ SLOW: Gets all columns
SELECT * FROM attendance WHERE user_id = ?

// ✅ FAST: Gets only needed columns
SELECT id, clock_in, clock_out FROM attendance WHERE user_id = ?
```

### 4. No Input Validation
```java
// ❌ DANGEROUS: Direct use
String reason = request.getParameter("reason");
db.insert(reason);  // XSS possible!

// ✅ SAFE: Validate first
String reason = request.getParameter("reason");
if (reason == null || reason.trim().isEmpty()) {
    error("Reason required");
    return;
}
if (reason.length() > 255) {
    error("Reason too long");
    return;
}
```

### 5. Hardcoded Credentials
```java
// ❌ DANGEROUS: Credentials in code
Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/jibble_db",
    "root", 
    "satyam"
);

// ✅ SECURE: In config file or environment variable
String password = System.getenv("DB_PASSWORD");
```

---

## 📄 Files Reference

| File | Type | Purpose |
|------|------|---------|
| `LoginServlet.java` | Backend | User authentication (username or email) |
| `SignupServlet.java` | Backend | User registration |
| `DashboardServlet.java` | Backend | Fetch attendance & leave data for display |
| `ClockInServlet.java` | Backend | Insert attendance record with NOW() |
| `ClockOutServlet.java` | Backend | Update clock_out time for active record |
| `LeaveRequestsServlet.java` | Backend | Submit & view leave requests |
| `EditLeaveServlet.java` | Backend | Fetch leave data for editing |
| `UpdateLeaveServlet.java` | Backend | Save updated leave data |
| `CancelLeaveServlet.java` | Backend | Delete pending leave requests |
| `DBConnection.java` | Backend | MySQL connection manager |
| `login.jsp` | Frontend | Login form |
| `signup.jsp` | Frontend | Registration form |
| `dashboard.jsp` | Frontend | Main interface with timer & tables |
| `leave-requests.jsp` | Frontend | Leave management page |
| `edit-leave.jsp` | Frontend | Edit leave form |
| `web.xml` | Config | Servlet URL mappings |
| `DATABASE_SETUP.sql` | Database | Initial schema creation |

---

## 📞 Contact & Support

**Project:** TimeTrack - Employee Time Tracking System  
**Built with:** Java, JSP, MySQL, Apache Tomcat  
**Last Updated:** April 20, 2026

---

**This documentation covers:**
- ✅ Project overview and architecture
- ✅ Complete database schema with CRUD operations
- ✅ Authentication & security flow
- ✅ Clock in/out workflow with database states
- ✅ Leave management operations
- ✅ UI/UX design system
- ✅ Deployment instructions
- ✅ Troubleshooting guide
- ✅ Future enhancement ideas
