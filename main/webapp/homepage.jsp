<%@page import="com.navya.Table"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        
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
	<form class="onOpen"  action="GetSessionController" method="get">
		Which query engine do you want to use?<br><br>
		<button id="mysql" name="sess" value="mysql">MySQL</button><br><br>
		<button id="hive" name="sess" value="hive">Hive</button><br><br>
		<button id="cass" name="sess" value="cass">Cassandra</button><br>
	</form>
</body>
</html>