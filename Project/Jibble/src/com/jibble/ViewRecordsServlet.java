package com.jibble;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * Servlet to fetch and display all employee records
 */
public class ViewRecordsServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, String>> records = new ArrayList<>();
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Fetch all records
            String sql = "SELECT id, name, clock_in, clock_out FROM employees ORDER BY clock_in DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, String> record = new HashMap<>();
                record.put("id", String.valueOf(rs.getInt("id")));
                record.put("name", rs.getString("name"));
                record.put("clock_in", rs.getTimestamp("clock_in") != null ? rs.getTimestamp("clock_in").toString() : "N/A");
                record.put("clock_out", rs.getTimestamp("clock_out") != null ? rs.getTimestamp("clock_out").toString() : "Still Clocked In");
                records.add(record);
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        request.setAttribute("records", records);
        RequestDispatcher dispatcher = request.getRequestDispatcher("view.jsp");
        dispatcher.forward(request, response);
    }
}
