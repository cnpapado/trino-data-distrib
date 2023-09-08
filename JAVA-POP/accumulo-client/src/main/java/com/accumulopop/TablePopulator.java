package com.yourcompany;

import org.apache.accumulo.core.client.BatchWriter;
import org.apache.accumulo.core.client.Connector;
import org.apache.accumulo.core.data.Mutation;
import org.apache.accumulo.core.data.Value;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;

public class TablePopulator {

    public static int populateTable(String dataSchemaPath, String dataFolder, String tableName, Connector connector) throws Exception {
        List<String> columns = TableStructureExtractor.getColumns(dataSchemaPath, tableName);

        String tableDataFilePath = "/home/user/trino-rhino/data/" + tableName + ".dat";

        System.out.println(tableDataFilePath);
        int rowCount = 0;

        try (BufferedReader reader = new BufferedReader(new FileReader(tableDataFilePath));

            BatchWriter writer = connector.createBatchWriter(tableName, null)) {
            String line;

            while ((line = reader.readLine()) != null) {
                String[] fields = line.split("\\|");
                String rowId = tableName + "_" + fields[0];
                Mutation m = new Mutation(rowId);
                for (int i = 0; i < columns.size(); i++) {
                    m.put("info", columns.get(i), new Value(fields[i].getBytes()));
                }
                writer.addMutation(m);
                rowCount++;
            }

            return rowCount;

        } catch (IOException e) {
            System.out.println("Exception Found, from populate Table!");
            return 0;
            // Properly handle exception in production scenarios.
        }


    }
}
