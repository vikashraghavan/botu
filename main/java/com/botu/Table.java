package com.botu;
import java.util.Arrays;

public class Table {
	private String[][] table;
	private String error;

	public String[][] getTable() {
		return table;
	}

	public void setTable(String[][] table) {
		this.table = table;
	}

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	@Override
	public String toString() {
		return "Table [table=" + Arrays.toString(table) + ", error=" + error + "]";
	}
	
}
