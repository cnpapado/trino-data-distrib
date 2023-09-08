package com.mycompany;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;

import java.util.Set;

public class AccumuloTableLister {

    private static final String ZOOKEEPERS = "127.0.0.1:2181";  // Your ZooKeeper information
    private static final String INSTANCE_NAME = "Acc-inst";   // Your Accumulo instance name
    private static final String USERNAME = "root";              // Your Accumulo username
    private static final String PASSWORD = "2001";          // Your Accumulo password

    public static void main(String[] args) {
        // Create a ZooKeeper instance.
        ClientConfiguration clientConfig = new ClientConfiguration().withInstance(INSTANCE_NAME).withZkHosts(ZOOKEEPERS);
        Connector connector;

        try {
            // Create a connector using the client configuration.
            connector = new ZooKeeperInstance(clientConfig).getConnector(USERNAME, new PasswordToken(PASSWORD));

            // Get the list of tables.
            Set<String> tables = connector.tableOperations().list();

            // Print the tables.
            for (String table : tables) {
                System.out.println(table);
            }

        } catch (AccumuloException | AccumuloSecurityException e) {
            e.printStackTrace();
        }
    }
}
