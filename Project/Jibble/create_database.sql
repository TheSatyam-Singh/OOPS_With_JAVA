-- ============================================================================
-- Jibble Employee Time Tracking System - Database Setup Script
-- ============================================================================
-- This script creates the employee_db database and all necessary tables

-- ============================================================================
-- 1. Create Database
-- ============================================================================
DROP DATABASE IF EXISTS employee_db;
CREATE DATABASE employee_db;
USE employee_db;

-- ============================================================================
-- 2. Create Tables
-- ============================================================================

-- ============================================================================
-- Table: user_accounts
-- Purpose: Store user authentication and profile information
-- ============================================================================
CREATE TABLE user_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- ============================================================================
-- Table: attendance
-- Purpose: Track employee clock-in and clock-out times
-- ============================================================================
CREATE TABLE attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    clock_in TIMESTAMP NOT NULL,
    clock_out TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user_accounts(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_clock_in (clock_in),
    INDEX idx_active_clockin (user_id, clock_out)
);

-- ============================================================================
-- Table: leave_requests
-- Purpose: Store employee leave request submissions
-- ============================================================================
CREATE TABLE leave_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    leave_from DATE NOT NULL,
    leave_to DATE NOT NULL,
    reason VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user_accounts(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_leave_from (leave_from),
    INDEX idx_user_status (user_id, status)
);

-- ============================================================================
-- 3. Sample Data (Optional - can be removed for production)
-- ============================================================================

-- Insert sample users
INSERT INTO user_accounts (full_name, email, username, password) VALUES
('John Doe', 'john@example.com', 'johndoe', 'password123'),
('Jane Smith', 'jane@example.com', 'janesmith', 'password123'),
('Mike Johnson', 'mike@example.com', 'mikej', 'password123');

-- Insert sample attendance records
INSERT INTO attendance (user_id, clock_in, clock_out) VALUES
(1, '2024-04-15 09:00:00', '2024-04-15 17:30:00'),
(1, '2024-04-16 08:45:00', '2024-04-16 18:15:00'),
(2, '2024-04-15 10:00:00', '2024-04-15 18:00:00'),
(2, '2024-04-16 09:30:00', NULL);

-- Insert sample leave requests
INSERT INTO leave_requests (user_id, leave_from, leave_to, reason, status) VALUES
(1, '2024-05-01', '2024-05-03', 'Personal vacation', 'Pending'),
(1, '2024-04-20', '2024-04-21', 'Medical appointment', 'Approved'),
(2, '2024-05-10', '2024-05-12', 'Family event', 'Pending');

-- ============================================================================
-- 4. End of Script
-- ============================================================================
-- Database setup complete. Tables are ready for use.
-- Connection Details:
--   Host: localhost
--   Port: 3306
--   Database: employee_db
--   User: root
--   Password: satyam
-- ============================================================================
