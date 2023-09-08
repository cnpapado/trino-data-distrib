//package com.mycompany;
//
//import org.apache.accumulo.core.client.*;
//import org.apache.accumulo.core.client.security.tokens.PasswordToken;
////import org.apache.accumulo.core.client.Accumulo;
//import org.apache.accumulo.core.client.security.tokens.AuthenticationToken;
//
//import java.util.Set;
//
//public class AccumuloListTablesTwo {
//
//    // Constants for Accumulo instance and credentials
//    private static final String INSTANCE_NAME = "Acc-inst";  // Typically the name of your Accumulo instance
//    private static final String ZOOKEEPERS = "127.0.0.1";               // Zookeeper quorum string
//    private static final String USERNAME = "root";                      // Your Accumulo username
//    private static final String PASSWORD = "2001";                    // Your Accumulo password
//
//    public static void main(String[] args) {
//        // Create Accumulo client configuration
//        ClientConfiguration clientConfig = ClientConfiguration.loadDefault().withInstance(INSTANCE_NAME).withZkHosts(ZOOKEEPERS);
//
//        // Connect to Accumulo
//        try (AccumuloClient client = Accumulo.newClient().from(clientConfig).as(USERNAME, new PasswordToken(PASSWORD)).build()) {
//            // Fetch list of tables
//            Set<String> tableNames = client.tableOperations().list();
//
//            // Print the list of tables
//            System.out.println("Accumulo Tables:");
//            for (String tableName : tableNames) {
//                System.out.println(tableName);
//            }
//
//        } catch (AccumuloException | AccumuloSecurityException e) {
//            System.err.println("Error connecting to Accumulo");
//            e.printStackTrace();
//        }
//    }
//}
