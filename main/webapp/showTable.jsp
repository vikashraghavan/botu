<%@page import="com.navya.Table"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
        
<!doctype html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<link href="https://cdnjs.cloudflare.com/ajax/libs/c3/0.7.0/c3.css" rel="stylesheet">
	<script src="https://d3js.org/d3.v5.min.js" charset="utf-8"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/0.7.0/c3.min.js"></script>
	<script src="script.js"></script>
	<link rel="stylesheet" type="text/css" href="style.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel = "icon" type = "image/png" href = "https://img.icons8.com/metro/420/source-code.png">
	<title>Big Data Visualization</title>
</head>
<body>
	<div class="toolbar">
		<span class="sessionTab">
			<button id="mysqlButton" class="sessionTabLinks" onclick="sessionOpenContent(event, 'mysql')">MySQL</button>  
			<button id="hiveButton" class="sessionTabLinks" onclick="sessionOpenContent(event, 'hive')">Hive</button>
			<button id="cassButton" class="sessionTabLinks" onclick="sessionOpenContent(event, 'cass')">Cassandra</button>
		</span>
		<span>Tabular/graphical big data query engine output through UI</span>
	</div>
	<div class="sidenav">
		<div id="mysql" class="sessionTabContent"><u>MySQL Tables:</u></div>
		<div id="hive"  class="sessionTabContent"><u>Hive Tables:</u></div>
		<div id="cass"  class="sessionTabContent"><u>Cassandra Tables:</u></div>
	</div>
	<div class="main">
	<div class="topHalf"><br>
		<div class="IParea">
			<form action="GetTableController" method="get">
				<input class="IPText" type="text" name="query" placeholder="Enter select query with database name">
				<span id="hidden"></span>
				<input type="submit" value="Execute >>" class="button">
			</form>
		</div>
		<br>
		<div id="error" class="error"></div>
		<div class="tab">
			<button id="tableButton" class="tabLinks" onclick="openContent(event, 'table')"><i class="fa fa-table" aria-hidden="true"></i><b>Table</b></button>
			<button id="graphButton" class="tabLinks" onclick="openContent(event, 'graph')"><i class="fa fa-line-chart" aria-hidden="true"></i><b>Graph</b></button>
		</div>
	</div>	
	<div class="content">
		<div id="table" class="tabContent" style="display:inline-block;">
			<% String[][] t = (String[][])request.getAttribute("temp");%>
			<form id = "XandY" action="javascript:void(0);" onsubmit="generateChart()">
				X-Axis: 
				<select name="xaxis">
					<% for (int j=0; t[0][j]!=null; j++) { %>
	    			<option value=<%= t[0][j] %>><%= t[0][j] %></option>
	    			<% } %>
	  			</select>
	  			<span style="padding-left: 60px;">Y-Axis:</span>
	  			<select name="yaxis">
					<% for (int j=0; t[0][j]!=null; j++) { %>
	    			<option value=<%= t[0][j] %>><%= t[0][j] %></option>
	    			<% } %>
	  			</select>
	  			<input type="submit" value="Generate chart" class="viewChartButton">
	  			<span id="chartGenerated" style="font-size: 0.7em;"></span>
  			</form>
  			<br><br>
			<table id="table">  
		        <% for(int i=0; t[i][0]!=null; i++) { %>
		        	<tr>
		        	<% for(int j=0; t[i][j]!=null; j++) { %> 
		                <td style="border:1px solid rgba(0,0,0,0.5); padding: 5px 20px; text-align:center;"><%= t[i][j] %></td> 
		            <% } %>
		        	</tr> 
	        	<% } %>
	        </table>
		</div>
		<div id="graph" class="tabContent">
			<div class="graphTab">
				<button  id="barchartButton" class="graphTabLinks" onclick="graphOpenContent(event, 'barChart')"><i class="fa fa-bar-chart" aria-hidden="true"></i><b>Bar Chart</b></button>
				<button class="graphTabLinks" onclick="graphOpenContent(event, 'lineChart')"><i class="fa fa-line-chart" aria-hidden="true"></i><b>Line Chart</b></button>
				<button class="graphTabLinks" onclick="graphOpenContent(event, 'pieChart')"><i class="fa fa-pie-chart" aria-hidden="true"></i><b>Pie Chart</b></button>
			</div>
			<br><br>
			<div class="graphContent">
				<div id="barChart" class="graphTabContent" style="display:inline-block;">
					<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>
				</div>
				<div id="lineChart" class="graphTabContent">
					<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>
				</div>
				<div id="pieChart" class="graphTabContent">
					<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>
				</div>
		
			</div>
		</div>
	</div>
	</div>
	<script>
	document.getElementById("tableButton").className += " active";
	<% String sess = (String)request.getAttribute("sess");
		String SQLdbs = (String)request.getAttribute("SQLdbs");
		String HIVEdbs = (String)request.getAttribute("HIVEdbs");
		String CASSdbs = (String)request.getAttribute("CASSdbs");%>
		var session = '<%=sess%>';
		if(session=="mysql"){
			var SQLdbs = '<%=SQLdbs%>';
			document.getElementById("hidden").innerHTML="<input type='hidden' name='sess' value="+session+" /><input type='hidden' name='SQLdbs' value="+SQLdbs+" /><input type='hidden' name='HIVEdbs' value="+HIVEdbs+" /><input type='hidden' name='CASSdbs' value="+CASSdbs+" />";
		    
			var allTables = SQLdbs.split(",");
			allTables.pop();
			SQLdbs="<table><tr><th>"+allTables[0].split(".")[0]+"</th></tr>";
			var db=allTables[0].split(".")[0];
			for (var l=0; l<allTables.length ; l++) {
				console.log(db,allTables[l].split(".")[0]);
				if (db == allTables[l].split(".")[0]) {
					SQLdbs+="<tr><td>"+allTables[l].split(".")[1]+"</td></tr>";
				}
				else {
					SQLdbs+="</table>";
					if (l<allTables.length) {
						SQLdbs+="<table>";
					}
					db = allTables[l].split(".")[0];
					SQLdbs+="<tr><th>"+allTables[l].split(".")[0]+"</th></tr>";
					SQLdbs+="<tr><td>"+allTables[l].split(".")[1]+"</td></tr>";
				}
			}
			SQLdbs+="</table>";
			
			document.getElementById("mysql").innerHTML="<br>"+SQLdbs;
		}else if(session=="hive"){
		
		var HIVEdbs = '<%=HIVEdbs%>';
		document.getElementById("hidden").innerHTML="<input type='hidden' name='sess' value="+session+" /><input type='hidden' name='SQLdbs' value="+SQLdbs+" /><input type='hidden' name='HIVEdbs' value="+HIVEdbs+" /><input type='hidden' name='CASSdbs' value="+CASSdbs+" />";
		
		
		
		allTables = HIVEdbs.split(",");
		allTables.pop();
		HIVEdbs="<table><tr><th>"+allTables[0].split(".")[0]+"</th></tr>";
		var db=allTables[0].split(".")[0];
		for (var l=0; l<allTables.length ; l++) {
			console.log(db,allTables[l].split(".")[0]);
			if (db == allTables[l].split(".")[0]) {
				HIVEdbs+="<tr><td>"+allTables[l].split(".")[1]+"</td></tr>";
			}
			else {
				HIVEdbs+="</table>";
				if (l<allTables.length) {
					HIVEdbs+="<table>";
				}
				db = allTables[l].split(".")[0];
				HIVEdbs+="<tr><th>"+allTables[l].split(".")[0]+"</th></tr>";
				HIVEdbs+="<tr><td>"+allTables[l].split(".")[1]+"</td></tr>";
			}
		}
		HIVEdbs+="</table>"; 

		console.log(session, SQLdbs, HIVEdbs);
		
		document.getElementById("hive").innerHTML="<br>"+HIVEdbs;
		}else if(session=="cass"){
			var CASSdbs = '<%=CASSdbs%>';
			document.getElementById("hidden").innerHTML="<input type='hidden' name='sess' value="+session+" /><input type='hidden' name='SQLdbs' value="+SQLdbs+" /><input type='hidden' name='HIVEdbs' value="+HIVEdbs+" /><input type='hidden' name='CASSdbs' value="+CASSdbs+" />";
		    
			var allTables = CASSdbs.split(",");
			allTables.pop();
			CASSdbs="<table><tr><th>"+allTables[0].split(".")[0]+"</th></tr>";
			var db=allTables[0].split(".")[0];
			for (var l=0; l<allTables.length ; l++) {
				console.log(db,allTables[l].split(".")[0]);
				if (db == allTables[l].split(".")[0]) {
					CASSdbs+="<tr><td>"+allTables[l].split(".")[1]+"</td></tr>";
				}
				else {
					CASSdbs+="</table>";
					if (l<allTables.length) {
						CASSdbs+="<table>";
					}
					db = allTables[l].split(".")[0];
					CASSdbs+="<tr><th>"+allTables[l].split(".")[0]+"</th></tr>";
					CASSdbs+="<tr><td>"+allTables[l].split(".")[1]+"</td></tr>";
				}
			}
			CASSdbs+="</table>";
			
			document.getElementById("cass").innerHTML="<br>"+CASSdbs;
			
		}
		if (session == "mysql") {
			 document.getElementById("mysqlButton").className += " active";
			 document.getElementById("mysql").style.display="inline-block";
		}
		else if (session == "hive") {
			document.getElementById("hiveButton").className += " active";
			document.getElementById("hive").style.display="inline-block";
		}
		else if(session == "cass"){
			document.getElementById("cassButton").className += " active";
			document.getElementById("cass").style.display="inline-block";
		}
	
	var xa;
	var ya;
	
	function generateChart() {
		xa=document.getElementById('XandY').xaxis.value;
		ya=document.getElementById('XandY').yaxis.value;
		console.log("X-Axis="+xa);
		console.log("Y-Axis="+ya);
		if (xa==ya) {
			document.getElementById('error').innerHTML = "Attributes selected for x-axis and y-axis are the same.<br><br>";
			//document.getElementById('chartGenerated').innerHTML = " Attributes selected for x-axis and y-axis are the same";
			document.getElementById('barChart').innerHTML = '<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>';
			document.getElementById('lineChart').innerHTML = '<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>';
			document.getElementById('pieChart').innerHTML = '<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>';
		}
		if (xa!=ya) {
			document.getElementById('error').innerHTML = "";
			document.getElementById('chartGenerated').innerHTML = "";
			console.log("In create chart");
			<% String a2s = (String)request.getAttribute("a2s");%>
			var tableAsString = '<%=a2s%>';
			console.log(tableAsString);
			var array = tableAsString.split(",");
			array.pop();
			var columns = array.pop();
			var rows = array.pop();
			var xAxis = xa;
			var yAxis = ya;
			var p=0;
			var tab = new Array(rows);
			for (var i=0; i<rows; i++) {
				 tab[i] = new Array(columns);
				 for (var j=0; j<columns; j++) {
					 tab[i][j] = array[p];
					 //console.log(tab[i][j]);
					 ++p;
				 }
			 }
			var x,y;
			for(var j=0; j<columns; j++) {
				if(tab[0][j]==xAxis) {
					x=j;
				}
				if(tab[0][j]==yAxis) {
					y=j;
				}
			}
			 var xValues = new Array(rows-1);
			 var yValues = new Array(rows);
			 p=0;
			 if (!tab[1][y].match(/[a-z]/g) && !tab[1][y].match(/[A-Z]/g)) {
				 yValues[0]='data1';
				 for (var i = 1; i<rows; i++) {
					 xValues[p] = tab[i][x];
					 yValues[p+1] = tab[i][y];
					 ++p;
				 }
				 var pieArray = new Array(rows-1);
				 for (var i=0; i<rows-1; i++) {
					 pieArray[i]=new Array(2);
					 pieArray[i][0]=tab[i+1][x];
					 pieArray[i][1]=tab[i+1][y];
				 }
				 //console.log("pieArray");
				 //console.log(pieArray);
				 var barChart = c3.generate({
						bindto: '#barChart',
						size: {
					        height: 300,
					        width: 700
					    },
					    data: {
					        columns: [
					            yValues
					        ],
					        names: {
					            data1: 'data1'
					        },
							type: 'bar'
					    },
						axis: {
					        x: {
								label: {text: xAxis/* , position: 'outer-center' */},
								tick: {
					                rotate: 90,
					                multiline: false
					            },
					            type: 'category',
					            categories: xValues
					        },
							y: {
								label: {text: yAxis,/*  position: 'outer-middle' */}
							}
							},			
					});
				 var lineChart = c3.generate({
						bindto: '#lineChart',
						size: {
							height: 300,
					        width: 700
					    },
					    data: {
					        columns: [
					            yValues
					        ],
					        names: {
					            data1: 'data1'
					        }
					    },
						axis: {
					        x: {
					        	label: {text: xAxis/* , position: 'outer-center' */},
					        	tick: {
					                rotate: 90,
					                multiline: false
					            },
					            type: 'category',
					            categories: xValues
					        },
							y: {
								label: {text: yAxis/* , position: 'outer-middle' */}
							}
							},				
					});
			 	var pieChart = c3.generate({
						bindto: '#pieChart',
						size: {
							height: 300,
					        width: 700
					    },
					    data: {
					        columns: pieArray,
					        type : 'pie',
					    }
					}); 
			 	//document.getElementById('chartGenerated').innerHTML = "Chart Generated, Open graph tab.";
				}
				else {
					document.getElementById('error').innerHTML = "Y-Axis attributes are strings.<br><br>";
					document.getElementById('barChart').innerHTML = '<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>';
					document.getElementById('lineChart').innerHTML = '<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>';
					document.getElementById('pieChart').innerHTML = '<pre><span style="color:red;"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> Incompatible data</span></pre>';
					//document.getElementById('chartGenerated').innerHTML = " Y-Axis attributes are strings, Unable to generate chart";
				}
			}
			var i, tabContent, tabLinks;
		  	tabContent = document.getElementsByClassName("tabContent");
		  	for (i = 0; i < tabContent.length; i++) {
		    	tabContent[i].style.display = "none";
		  	}
		  	tabLinks = document.getElementsByClassName("tabLinks");
		  	for (i = 0; i < tabLinks.length; i++) {
		    	tabLinks[i].className = tabLinks[i].className.replace(" active", "");
		  	}
		  	document.getElementById("graph").style.display = "block";
		  	document.getElementById("graphButton").className += " active";
		}
	</script>
</body>
</html>
