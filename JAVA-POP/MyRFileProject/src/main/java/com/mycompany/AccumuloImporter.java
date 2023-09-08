package com.mycompany;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.client.admin.TableOperations;
import org.apache.accumulo.core.client.security.tokens.PasswordToken;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
//InputStream accumuloConfig = this.getClass().getResourceAsStream("/accumulo-site.xml");


public class AccumuloImporter {

    public static void main(String[] args) {
        String instanceName = "Acc-inst"; // Replace with your instance name
        String zookeepers = "127.0.0.1:9997"; // Adjust as needed
        String user = "root"; // Your Accumulo user
        String password = "2001"; // Your Accumulo password
        String tableName = "testTable-2"; // Your target table
        String importDir = "/accumulo-imports"; // HDFS directory with your .rf files
        String failureDir = "/accumulo-imports/failures"; // HDFS directory for failures

        ZooKeeperInstance instance = new ZooKeeperInstance(instanceName, zookeepers);
        try {
            Connector connector = instance.getConnector(user, new PasswordToken(password));
            TableOperations tableOps = connector.tableOperations();

            // Check if the table exists, if not, create it
            if (!tableOps.exists(tableName)) {
                tableOps.create(tableName);
            }

            // Import the directory
            tableOps.importDirectory(tableName, importDir, failureDir, false);

            System.out.println("Data imported successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Failed to import data into Accumulo.");
        }
    }
}
