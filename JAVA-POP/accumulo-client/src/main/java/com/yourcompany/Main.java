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

    private static final Map<String, Integer> one_GB_rows;

    static {
        one_GB_rows = new HashMap<>();
        one_GB_rows.put("call_center", 6);
        one_GB_rows.put("catalog_page", 11718);
        one_GB_rows.put("catalog_returns", 144067);
        one_GB_rows.put("catalog_sales", 1441548);
        one_GB_rows.put("customer_address", 50000);
        one_GB_rows.put("customer", 100000);
        one_GB_rows.put("customer_demographics", 1920800);
        one_GB_rows.put("date_dim", 73049);
        one_GB_rows.put("dbgen_version", 1);
        one_GB_rows.put("household_demographics", 7200);
        one_GB_rows.put("income_band", 20);
        one_GB_rows.put("inventory", 11745000);
        one_GB_rows.put("item", 18000);
        one_GB_rows.put("promotion", 300);
        one_GB_rows.put("reason", 35);
        one_GB_rows.put("ship_mode", 20);
        one_GB_rows.put("store", 12);
        one_GB_rows.put("store_returns", 287514);
        one_GB_rows.put("store_sales", 2880404);
        one_GB_rows.put("time_dim", 86400);
        one_GB_rows.put("warehouse", 5);
        one_GB_rows.put("web_page", 60);
        one_GB_rows.put("web_returns", 71763);
        one_GB_rows.put("web_sales", 719384);
        one_GB_rows.put("web_site", 30);
    }

    public static void main(String[] args) throws Exception {
        // Hardcoded values as per your request
        String tpcdsDataSchemaPath = "/home/yiannos/Desktop/Projects/Trino-Github/trino-rhino/DSGen-software-code-3.2.0rc1/tools/tpcds.sql";
        String tpcdsDataFolder = "../data/";

        String host = "127.0.0.1";
        String port = "2181";
        String user = "root";
        String password = "****";

        Instance instance = new ZooKeeperInstance("Acc-inst", host + ":" + port);
        Connector connector = instance.getConnector(user, new PasswordToken(password));

        System.out.println("\033[1m----Loading tables to Accumulo----\033[0m");
        long totalStartTime = System.currentTimeMillis();
        int iter = 0;
        for (String tableName : data_tables) {
            iter+=1;
            if (iter==10){break;}
            long tableStartTime = System.currentTimeMillis();
            System.out.println("\033[36mLoading table \033[1m" + tableName + "\033[36m...\033[0m");

            if (!connector.tableOperations().exists(tableName)) {
                connector.tableOperations().create(tableName);
            }

            int rowsWritten = TablePopulator.populateTable(tpcdsDataSchemaPath, tpcdsDataFolder, tableName, connector);
            int expectedRows = one_GB_rows.get(tableName);
            System.out.println(rowsWritten + " Rows loaded from table " + tableName);

            if (rowsWritten != expectedRows) {
                System.out.println("\033[91m" + rowsWritten + " were loaded to table " + tableName + ", " + expectedRows + " were expected!\033[0m");
            }

            long tableEndTime = System.currentTimeMillis();
            System.out.println("\033[92m" + tableName + " table was loaded successfully in " + (tableEndTime - tableStartTime) / 1000.0 + " seconds!\033[0m");
        }

        long totalEndTime = System.currentTimeMillis();
        System.out.println("Loading all tables took: \033[1m" + (totalEndTime - totalStartTime) / 1000.0 + " seconds.\033[0m");
    }
}
