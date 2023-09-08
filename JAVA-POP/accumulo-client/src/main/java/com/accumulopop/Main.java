package com.yourcompany;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class Main {
    private static final List<String> data_tables = Arrays.asList(
            "call_center", "catalog_page", "catalog_returns", "catalog_sales",
            "customer_address", "customer", "customer_demographics", "date_dim",
            "dbgen_version", "household_demographics", "income_band", "inventory",
            "item", "promotion", "reason", "ship_mode", "store", "store_returns",
            "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
            "web_sales", "web_site"
    );

    public static void main(String[] args) throws Exception {
        // Hardcoded values as per your request
        String tpcdsDataSchemaPath = "/home/user/accumulo/lib/ext/tpcds.sql";
        String tpcdsDataFolder = "/home/user/trino-rhino/data/";

        String host = "localhost";
        String port = "2181";
        String user = "root";
        String password = "secret";

        Instance instance = new ZooKeeperInstance("trino_accumulo", host + ":" + port);
        Connector connector = instance.getConnector(user, new PasswordToken(password));

        System.out.println("\033[1m----Loading tables to Accumulo----\033[0m");
        long totalStartTime = System.currentTimeMillis();
        for (String tableName : data_tables) {
            long tableStartTime = System.currentTimeMillis();
            System.out.println("\033[36mLoading table \033[1m" + tableName + "\033[36m...\033[0m");

            if (!connector.tableOperations().exists(tableName)) {
                connector.tableOperations().create(tableName);
            }

            int rowsWritten = TablePopulator.populateTable(tpcdsDataSchemaPath, tpcdsDataFolder, tableName, connector);
            System.out.println(rowsWritten + " Rows loaded from table " + tableName);

            long tableEndTime = System.currentTimeMillis();
            System.out.println("\033[92m" + tableName + " table was loaded successfully in " + (tableEndTime - tableStartTime) / 1000.0 + " seconds!\033[0m");
        }

        long totalEndTime = System.currentTimeMillis();
        System.out.println("Loading all tables took: \033[1m" + (totalEndTime - totalStartTime) / 1000.0 + " seconds.\033[0m");
    }
}
