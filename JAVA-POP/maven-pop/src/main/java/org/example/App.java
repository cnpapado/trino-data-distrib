package org.example;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class App {

    private App() {}

public static void main(String[] args) throws AccumuloException, AccumuloSecurityException {

        // Connection Details
        String instanceName = "Acc-inst";
        String zooServers = "127.0.0.1:2181"; //e.g., "localhost:2181"
        String user = "root";
        String password = "2001";

        ZooKeeperInstance instance = new ZooKeeperInstance(instanceName, zooServers);
        Connector conn = instance.getConnector(user, new PasswordToken(password));

            // List tables
        Iterable<String> tableNames = conn.tableOperations().list();
        for (String tableName : tableNames) {
            System.out.println(tableName);
        }
    }
}
