package com.accumulopop;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import java.util.Arrays;
import java.util.List;


public class Main {
    static List<String> validTableNames = Arrays.asList("inventory", "store_returns", "catalog_returns", "web_returns", "web_sales", "catalog_sales", "store_sales");

    public static void main(String[] args) throws Exception {

        if (args.length != 3) {
            System.out.println("Usage: <program> <table_name>");
            return;
        }
        // Get table name from the command line arguments
        String tableName = args[0];
        String datFileName = args[1];
        String rowCounter = args[2];

        // Hardcoded values
        String tpcdsDataSchemaPath = "/home/user/accumulo/lib/ext/tpcds.sql";
        String host = "localhost";
        String port = "2181";
        String user = "***";
        String password = "***";
        String accumuloInstance = "***";
        String dataFilesPath = "/home/user/data/";

        //Establish connection to Accumulo
        Instance instance = new ZooKeeperInstance(accumuloInstance, host + ":" + port);
        Connector connector = instance.getConnector(user, new PasswordToken(password));

        long tableStartTime = System.currentTimeMillis();
        System.out.println("\033[36mLoading table \033[1m" + tableName + "\033[36m...\033[0m");

        int rowsWritten = 0;
        if (validTableNames.contains(tableName)) {
             rowsWritten = TablePopulator.populateTable(dataFilesPath, tpcdsDataSchemaPath, tableName, datFileName, connector, true, rowCounter);
        } else {
            rowsWritten = TablePopulator.populateTable(dataFilesPath, tpcdsDataSchemaPath, tableName, datFileName, connector, false, rowCounter);
        }

        // Print rowsWritten and time!
        System.out.println(rowsWritten + " Rows loaded from table " + tableName);
        long tableEndTime = System.currentTimeMillis();
        System.out.println("\033[92m" + tableName + " table was loaded successfully in " + (tableEndTime - tableStartTime) / 1000.0 + " seconds!\033[0m");
    }
}


