package com.yourcompany;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import org.apache.accumulo.core.data.Mutation;
import org.apache.accumulo.core.data.Value;

public class TableCreator {

    private static final String TABLE_NAME = "mockDataTable";

    public static void main(String[] args) {
        // Define Accumulo connection parameters
        String instanceName = "Acc-inst";
        String zooServers = "127.0.0.1:2181";
        String user = "root";
        String password = "***";

        try {
            // Connect to Accumulo
            Instance instance = new ZooKeeperInstance(instanceName, zooServers);
            Connector connector = instance.getConnector(user, new PasswordToken(password));

            // Create table if it doesn't exist
            if (!connector.tableOperations().exists(TABLE_NAME)) {
                connector.tableOperations().create(TABLE_NAME);
                System.out.println("Table " + TABLE_NAME + " created successfully.");
            } else {
                System.out.println("Table " + TABLE_NAME + " already exists.");
            }

            // Add mock data to the table
            BatchWriterConfig config = new BatchWriterConfig();
            BatchWriter writer = connector.createBatchWriter(TABLE_NAME, config);

            for (int i = 1; i <= 100; i++) {
                Mutation mutation = new Mutation("row" + i);
                mutation.put("info", "name", new Value(("name" + i).getBytes()));
                mutation.put("info", "age", new Value(Integer.toString(20 + (i % 5)).getBytes()));
                writer.addMutation(mutation);
            }

            writer.close();

            System.out.println("Mock data added to " + TABLE_NAME);

        } catch (AccumuloException | AccumuloSecurityException | TableExistsException | TableNotFoundException e) {
            System.out.println("Exception Caught!");
        }
    }
}
