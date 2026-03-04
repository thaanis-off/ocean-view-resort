package com.app.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
 
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3307/ocean_view_resort";
    private static final String USER = "root";
    private static final String PASS = "";
 
    // loads driver ONCE when class is first used
    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { throw new RuntimeException(e); }
    }
 
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}

