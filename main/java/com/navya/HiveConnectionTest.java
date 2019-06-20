package com.navya;

import java.sql.SQLException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.DriverManager;

public class HiveConnectionTest {
   private static String driverName = "org.apache.hadoop.hive.jdbc.HiveDriver";
   
   public static Statement conn() throws ClassNotFoundException, SQLException {
	   Class.forName("org.apache.hive.jdbc.HiveDriver");
		Connection conn = DriverManager.getConnection("jdbc:hive2://192.168.115.128:10000/default", "", "");
		//System.out.println(conn.isClosed());
     Statement stmt = conn.createStatement();
     return stmt;
   }
   
   
   
   public static void main(String[] args) throws SQLException, ClassNotFoundException, IOException {
      // Register driver and create driver instance
	   Statement stmt = null;
	   try {
	   stmt=conn();
      
	  while(true) {
		  System.out.println("Give query: ");
	  BufferedReader reader =
              new BufferedReader(new InputStreamReader(System.in));
   String query = reader.readLine();
   System.out.println(query);
	  
	  
	  if(stmt.isClosed()==true) { 
		  stmt=conn(); 
	  }
	  
      ResultSet rs = stmt.executeQuery(query);
      while (rs.next()) {
		System.out.println( rs.getString(1)); 
      }
		
	  }
	   }
	   finally {
		   stmt.getConnection().close();
	   }
   }
}