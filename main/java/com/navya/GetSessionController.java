package com.navya;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
//import com.datastax.driver.core.Cluster;
//import com.datastax.driver.core.Row;
//import com.datastax.driver.core.Session;
//import java.util.Scanner; 

//import com.datastax.driver.core.ResultSet;

//import com.datastax.driver.core.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GetSessionController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public ConnGetSet stmt;
	public static Connection conn;
	//private com.datastax.driver.core.ResultSet v;
	public static Statement sconn() throws ClassNotFoundException, SQLException {
		System.out.println("In MySQL connection function");
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://10.113.34.36:3306","ubuntu","Vikash@2001");
	    Statement stmt = conn.createStatement();
	    System.out.println("Connection success");  
	    return stmt;
	}
	
	public static Statement hconn() throws ClassNotFoundException, SQLException {
		System.out.println("In HIVE connection function");
		Class.forName("org.apache.hive.jdbc.HiveDriver");
		conn = DriverManager.getConnection("jdbc:hive2://10.113.34.36:10000", "ubuntu", "password");
	    Statement stmt = conn.createStatement();
	    System.out.println("Connection success"); 
	    return stmt;
	}
	
	public static Statement cconn() throws ClassNotFoundException, SQLException {
		System.out.println("In CASSANDRA connection function");
		Class.forName("org.apache.cassandra.cql.jdbc.CassandraDriver");
		conn = DriverManager.getConnection("jdbc:cassandra://10.113.34.36:9160");
	    Statement stmt = conn.createStatement();
	    System.out.println("Connection success"); 
	    return stmt;
	}
	
	public static void close() throws SQLException {
		conn.close();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	/*	try {
		close();
		}
		catch (Exception e) {
			  e.printStackTrace(); 
			  }*/
		String sess = (String)request.getParameter("sess");
		
		try {
			if("mysql".contentEquals(sess))
			{
			Statement sstmt = sconn();
			stmt=new ConnGetSet(sstmt, null, null);
			}else if("hive".contentEquals(sess)) {
			Statement hstmt = hconn();
			stmt=new ConnGetSet(null, hstmt,null);
			}else if("cass".contentEquals(sess)) {
			Statement cstmt = cconn();
			stmt=new ConnGetSet(null, null,cstmt);	
			}
		} 
		catch (Exception e1) {
			e1.printStackTrace();
		}
		
		System.out.println("***Entering GetSessionController***");
		String SQLdbs="";
		String HIVEdbs="";
		String CASSdbs="";
		
		System.out.println("Session = " + sess);
		if("mysql".contentEquals(sess)) {
			try { 
				ResultSet srs = stmt.getMysqlStmt().executeQuery("SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema NOT IN ( 'information_schema', 'performance_schema', 'mysql', 'result_webapp', 'hive', 'sys', 'world');");
				while (srs.next()) {
					SQLdbs += srs.getString(1) +"."+ srs.getString(2) +",";
				}
				System.out.println("SQLdbs = "+SQLdbs);
			}
			catch (Exception e) {
				  e.printStackTrace(); 
				  }
			HttpSession session = request.getSession();
			session.setAttribute("sess", sess);
			session.setAttribute("SQLdbs", SQLdbs);
			request.setAttribute("sess", sess); 
			request.setAttribute("SQLdbs", SQLdbs);
			RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
			rd.forward(request, response);
			System.out.println("***Exiting GetSessionController***");
		}else if("hive".contentEquals(sess)) {
		
		try {
			String[] dbs = new String[100];
			int p=0;
			ResultSet hrs = stmt.getHiveStmt().executeQuery("show databases");
		      while (hrs.next()) {
		    	  dbs[p]=hrs.getString(1);
		    	  ++p;
		      }
		      for (int i=0; dbs[i]!=null; i++) {
		    	  stmt.getHiveStmt().execute("use "+dbs[i]);
		    	  hrs = stmt.getHiveStmt().executeQuery("show tables");
		    	  while (hrs.next()) {
		    		  HIVEdbs += dbs[i] +"."+ hrs.getString(1) +",";
		          }
		      } 
			System.out.println("HIVEdbs = "+HIVEdbs);
			} 
		catch (Exception e) {
		  e.printStackTrace(); 
		  }
		
		 
		HttpSession session = request.getSession();
		session.setAttribute("sess", sess);
		
		session.setAttribute("HIVEdbs", HIVEdbs);
		
		request.setAttribute("sess", sess); 
		
		request.setAttribute("HIVEdbs", HIVEdbs);
		RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
		rd.forward(request, response);
		System.out.println("***Exiting GetSessionController***");
	    
		
		}else if("cass".contentEquals(sess)) {
		    try {
		        ResultSet rs = stmt.getCassStmt().executeQuery("SELECT keyspace_name FROM system_schema.keyspaces;");
		        String[] dbs = new String[100];
				String[] fdbs = new String[100];
				int p=0;
		        while (rs.next()) {
		            dbs[p]=rs.getString(1);
			    	 p++;
		        }
		        for(int d=0;d<p-5;d++) {
					fdbs[d]=dbs[d];
					//System.out.println(fdbs[d]);
				}
		        int q=0;
				String[] t = new String[100];
				for (int i=0; fdbs[i]!=null; i++) {
			    	  stmt.getCassStmt().execute("use "+fdbs[i]+";");
			    	  rs = stmt.getCassStmt().executeQuery("SELECT table_name FROM system_schema.tables WHERE keyspace_name = '"+fdbs[i]+"';");
			    	  while (rs.next()) {
			    		  t[q]=rs.getString(1);
			    		  CASSdbs += fdbs[i] +"."+ t[q] +",";
			    		  
				    	  q++;
			          }
			      } 
				
				System.out.println("CASSdbs = "+CASSdbs);
		    } catch (SQLException e) {
		        e.printStackTrace();
		    } 
		    HttpSession session = request.getSession();
			session.setAttribute("sess", sess);
			session.setAttribute("CASSdbs", CASSdbs);
			request.setAttribute("sess", sess); 
			request.setAttribute("CASSdbs", CASSdbs);
			RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
			rd.forward(request, response);
			System.out.println("***Exiting GetSessionController***");
	    }
	}
}
