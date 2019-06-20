<!doctype html>
<html>
<head>
	<meta charset="ISO-8859-1">
    <script src="https://d3js.org/d3.v4.min.js" charset="utf-8"></script>
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
		<div class="error"></div>
		<div class="tab">
			<button class="tabLinks" onclick="openContent(event, 'table')"><i class="fa fa-table" aria-hidden="true"></i><b>Table</b></button>
			<button class="tabLinks" onclick="openContent(event, 'graph')"><i class="fa fa-line-chart" aria-hidden="true"></i><b>Graph</b></button>
		</div>
	</div>	
	<div class="content">
		<div id="table" class="tabContent" style="display:inline-block;">
			Table to be displayed here.
		</div>
		<div id="graph" class="tabContent">
			Graph to be displayed here.
		</div>
	</div>
	</div>
	<script>
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
	</script>
</body>
</html>