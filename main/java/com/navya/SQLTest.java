package com.navya;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.DriverManager;

public class SQLTest {
   private static String driverName = "org.apache.hadoop.hive.jdbc.HiveDriver";
   
   public static void main(String[] args) throws SQLException, ClassNotFoundException {
   
      // Register driver and create driver instance
      //Class.forName(driverName);
      
      // get connection
	  String[] dbs = new String[100];
	  int p=0;
	  String result="";
      Class.forName("org.apache.hive.jdbc.HiveDriver");
      Connection con = DriverManager.getConnection("jdbc:hive2://192.168.115.128:10000/default", "", "");
      Statement stmt = con.createStatement();
      ResultSet rs = stmt.executeQuery("show databases");
      while (rs.next()) {
    	  dbs[p]=rs.getString(1);
    	  ++p;
      }
      for (int i=0; dbs[i]!=null; i++) {
    	  stmt.execute("use "+dbs[i]);
    	  rs = stmt.executeQuery("show tables");
    	  while (rs.next()) {
        	  result += dbs[i] +"."+ rs.getString(1) +",";
          }
      }      
      System.out.println(result);
      
      con.close();
   }
}
