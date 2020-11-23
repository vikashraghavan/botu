package com.botu;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GetTableController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("***Entering GetTableController***");
		String query = request.getParameter("query");
		String sess = request.getParameter("sess");
		String SQLdbs = request.getParameter("SQLdbs");
		String HIVEdbs = request.getParameter("HIVEdbs");
		String CASSdbs = request.getParameter("CASSdbs");
		System.out.println("sess = '"+sess+"'");
		System.out.println("SQLdbs = "+SQLdbs);
		System.out.println("HIVEdbs = "+HIVEdbs);
		System.out.println("CASSdbs = "+CASSdbs);
		request.setAttribute("sess", sess);
		request.setAttribute("SQLdbs", SQLdbs);
		request.setAttribute("HIVEdbs", HIVEdbs);
		request.setAttribute("CASSdbs", CASSdbs);
		
		if (query=="") {
			String error = "Query field is empty";
			
			request.setAttribute("error", error);
			RequestDispatcher rd = request.getRequestDispatcher("error.jsp");
			rd.forward(request, response);
		}
		else {
			System.out.println("Query sent from controller: "+query);
			TableDao dao = new TableDao();
			Table t1 = dao.getTable(query, sess);
			
			String[][] temp = t1.getTable();
			String error = t1.getError();
			
			if(error!=null) {
				request.setAttribute("error", error);
				RequestDispatcher rd = request.getRequestDispatcher("error.jsp");
				rd.forward(request, response);
			}
			String a2s = "";
			int i=0, j = 0;
			for (i=0; temp[i][0]!=null; i++) {
				for (j=0; temp[i][j]!=null; j++) {
					a2s+=temp[i][j]+",";
				}
			}
			System.out.println("***Processing completed***");
			a2s+=i+","+j+",";
			request.setAttribute("temp", temp);
			request.setAttribute("a2s", a2s);
			RequestDispatcher rd = request.getRequestDispatcher("showTable.jsp");
			rd.forward(request, response);
		}
		System.out.println("***Exiting GetTableController***");
	}
}
