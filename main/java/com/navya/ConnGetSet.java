package com.navya;

import java.sql.Statement;

public class ConnGetSet {
	public Statement mysqlStmt;
	public Statement cassStmt;
	public Statement hiveStmt;

	public ConnGetSet(Statement mysqlStmt, Statement hiveStmt, Statement cassStmt ) {
		this.mysqlStmt = mysqlStmt;
		this.hiveStmt = hiveStmt;
		this.cassStmt = cassStmt;
	}
	
	
	public Statement getMysqlStmt() {
		return mysqlStmt;
	}

	public void setMysqlStmt(Statement mysqlStmt) {
		this.mysqlStmt = mysqlStmt;
	}
	
	public Statement getCassStmt() {
		return cassStmt;
	}

	public void setCassStmt(Statement cassStmt) {
		this.cassStmt = cassStmt;
	}

	public Statement getHiveStmt() {
		return hiveStmt;
	}

	public void setHiveStmt(Statement hiveStmt) {
		this.hiveStmt = hiveStmt;
	}

	
}
