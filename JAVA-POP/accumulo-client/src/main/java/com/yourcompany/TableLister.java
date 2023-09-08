package com.yourcompany;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;

import java.util.Set;

public class TableLister {

    public static void main(String[] args) throws AccumuloException, AccumuloSecurityException {
        // Define Accumulo connection parameters
        String instanceName = "Acc-inst";
        String zooServers = "127.0.0.1";
        String user = "root";
        String password = "2001";

        // Connect to Accumulo
        Instance instance = new ZooKeeperInstance(instanceName, zooServers);
        Connector connector = instance.getConnector(user, new PasswordToken(password));

        // Fetch and print tables
        Set<String> tables = connector.tableOperations().list();
        System.out.println("Accumulo Tables:");
        for (String table : tables) {
            System.out.println(table);
        }

    }
}
