package com.mycompany;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.security.tokens.AuthenticationToken;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;

import java.util.Set;

import static java.lang.System.getProperties;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

//...

public class AccumuloListTables {
    public static void main(String[] args) {
        System.setProperty("java.net.preferIPv4Stack", "true");
        java.security.Security.setProperty("networkaddress.cache.ttl", "0");
        java.security.Security.setProperty("networkaddress.cache.negative.ttl", "0");

        Properties accumuloProps = new Properties();
        try {
            accumuloProps.load(new FileInputStream("/home/yiannos/Desktop/Projects/Trino-Github/trino-rhino/JAVA-POP/MyRFileProject/src/main/java/com/mycompany/client.conf")); // Provide the path to your client.conf
        } catch (IOException e) {
            e.printStackTrace();
            return; // exit if unable to load the configuration
        }

        try {
            Instance instance = new ZooKeeperInstance(
                    accumuloProps.getProperty("accumulo.instanceName"),
                    accumuloProps.getProperty("accumulo.zooKeepers")
            );

            String principal = accumuloProps.getProperty("accumulo.username");
            AuthenticationToken token =
                    new PasswordToken(accumuloProps.getProperty("accumulo.password"));
            Connector connector = instance.getConnector(principal, token);

            Set<String> tables = connector.tableOperations().list();

            System.out.println("Tables in Accumulo:");
            for (String table : tables) {
                System.out.println(table);
            }
        } catch (AccumuloException | AccumuloSecurityException e) {
            e.printStackTrace();
        }
    }
}
