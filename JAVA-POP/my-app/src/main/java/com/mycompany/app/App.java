package com.mycompany.app;

import java.util.Random;

import org.apache.accumulo.core.client.*;
import org.apache.accumulo.core.data.Mutation;
import org.apache.accumulo.core.data.Value;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class App {

    private static final Logger log = LoggerFactory.getLogger(App.class);

    private App() {}

    public static Value createValue(long rowId, int size) {
        Random r = new Random(rowId);
        byte[] value = new byte[size];
        r.nextBytes(value);
        
        // transform to printable chars
        for (int j = 0; j < value.length; j++) {
            value[j] = (byte) (((0xff & value[j]) % 92) + ' ');
        }

        return new Value(value);
    }

    public static void main(String[] args) throws AccumuloException, AccumuloSecurityException, TableNotFoundException {
        
        // Connection Details
        String instanceName = "Acc-inst";
        String zooServers = "127.0.0.1:2181"; //e.g., "localhost:2181"
        String user = "root";
        String password = "2001";
        String tableName = "catalog_returns"; // change as needed

        ZooKeeperInstance instance = new ZooKeeperInstance(instanceName, zooServers);
        Connector conn = instance.getConnector(user, new PasswordToken(password));

        // Create table if it doesn't exist
        if (!conn.tableOperations().exists(tableName)) {
            conn.tableOperations().create(tableName);
        }

        // Create and write the data using BatchWriter
        try (BatchWriter bw = conn.createBatchWriter(tableName, new BatchWriterConfig())) {
            for (int i = 0; i < 10_000; i++) {
                int row = i;
                Mutation m = new Mutation(String.format("row_%010d", row));
                // create a random value that is a function of row id for verification purposes
                m.put("foo", "1", createValue(row, 50));
                bw.addMutation(m);
                if (i % 1000 == 0) {
                    log.trace("wrote {} entries", i);
                }
            }
        }
    }
}
