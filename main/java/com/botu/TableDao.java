package com.botu;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.*;

import org.apache.hive.service.cli.HiveSQLException;

public class TableDao {
	public ConnGetSet stmt;
	
	public static Statement sconn() throws ClassNotFoundException, SQLException {
		System.out.println("In MySQL connection function");
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://10.113.34.36:3306","ubuntu","Vikash@2001");
	    Statement stmt = conn.createStatement();
	    return stmt;
	}
	
	public static Statement hconn() throws ClassNotFoundException, SQLException {
		System.out.println("In HIVE connection function");
		Class.forName("org.apache.hive.jdbc.HiveDriver");
		Connection conn = DriverManager.getConnection("jdbc:hive2://10.113.34.36:10000", "ubuntu", "password");
	    Statement stmt = conn.createStatement();
	    return stmt;
	}
	
	public static Statement cconn() throws ClassNotFoundException, SQLException {
		System.out.println("In CASSANDRA connection function");
		Class.forName("org.apache.cassandra.cql.jdbc.CassandraDriver");
		Connection conn = DriverManager.getConnection("jdbc:cassandra://10.113.34.36:9160");
	    Statement stmt = conn.createStatement();
	    System.out.println("Connection success"); 
	    return stmt;
	}
	
	public Table getTable(String query, String sess) {
		
		String[] q = query.split(";");
		query = q[0];
		try {
			if("mysql".contentEquals(sess)) {
			Statement sstmt = sconn();
			stmt=new ConnGetSet(sstmt,null, null);
			}else if("hive".contentEquals(sess)) {
			Statement hstmt = hconn();
			stmt=new ConnGetSet(null, hstmt, null);
			}else if("cass".contentEquals(sess)) {
			Statement cstmt = cconn();
			stmt=new ConnGetSet(null, null,cstmt);	
			}
		} 
		catch (Exception e1) {
			e1.printStackTrace();
		}
		while(true) {
		System.out.println("***Entering TableDao***");
		System.out.println("Connection success");  
		Table t = new Table(); 
		String[][] result = new String[100][100]; 
		String tmp="";
		int i=0, j=0, c=1; 
		try { 
			ResultSet rs;
			ResultSetMetaData rsmd;
			if (sess.equals("mysql")) {
				rs = stmt.getMysqlStmt().executeQuery(query);
				rsmd = rs.getMetaData();	
			}
			else if(sess.contentEquals("hive")) {
				rs = stmt.getHiveStmt().executeQuery(query);
				rsmd = rs.getMetaData();	
			}
			else  {
				rs = stmt.getCassStmt().executeQuery(query);
				rsmd = rs.getMetaData();	
			}
			  
			try { 
				while (true) { 
					tmp = rsmd.getColumnName(c); 
					if (sess.equals("hive")){
						String[] a = tmp.split("[.]");
						tmp=a[1];
					}
					result[i][c-1]=tmp; 
					++c; 
					} 
				}
			catch (Exception e){ 
				System.err.println(e); 
				} 
			--c; 
			++i; 
			while (rs.next()) {
				for(j=0;j<c;j++) { 
					result[i][j] = rs.getString(j+1); 
					} 
				++i; 
				}
			t.setTable(result);
			} 
		catch (SQLSyntaxErrorException e) { 
			System.err.println(e); 
			StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String exceptionAsString = sw.toString();
            String[] arrOfStr = exceptionAsString.split("at com.mysql.cj.jdbc.exceptions.SQLError", 2);  
			t.setError(arrOfStr[0]);
			}
		catch (HiveSQLException e) { 
			System.err.println(e); 
			StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String exceptionAsString = sw.toString();
            String[] arrOfStr = exceptionAsString.split("in joinSource", 2);
            String[] arrOfStr2 = arrOfStr[0].split("at org.apache.hive.jdbc.Utils.", 2);
			t.setError(arrOfStr2[0]);
			}
		catch (Exception e) {
			System.err.println(e); 
		}
		System.out.println("***Exiting TableDao***");
		return t; 
	}
	}
}
