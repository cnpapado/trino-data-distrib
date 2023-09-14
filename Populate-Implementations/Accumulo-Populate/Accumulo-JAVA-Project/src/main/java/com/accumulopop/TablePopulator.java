package com.accumulopop;

import org.apache.accumulo.core.client.BatchWriter;
import org.apache.accumulo.core.client.Connector;
import org.apache.accumulo.core.data.Mutation;
import org.apache.accumulo.core.data.Value;
import org.apache.hadoop.io.Text;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;

public class TablePopulator {

    public static int populateTable(String dataFilesPath, String dataSchemaPath, String tableName, String datFileName, Connector connector, Boolean multiple_primary, String rowCounter) throws Exception {
        // Extract schema from tpcds.sql
        TableSchema tableSchema = TableStructureExtractor.getColumns(dataSchemaPath, tableName);
        List<String> columns = tableSchema.columns();
        List<String> columnTypes = tableSchema.columnTypes();

        String tableDataFilePath = dataFilesPath + datFileName;

        int rowCount = 0;
        try (BufferedReader reader = new BufferedReader(new FileReader(tableDataFilePath));
             BatchWriter writer = connector.createBatchWriter(tableName, null)) {

            String line;
            int my_new_row_id= Integer.parseInt(rowCounter);
            while ((line = reader.readLine()) != null) {
                String[] fields = line.split("\\|");

                String rowId;
                if(multiple_primary){
                    rowId = String.valueOf(my_new_row_id);
                    my_new_row_id++;
                }else {
                    rowId = fields[0];
                }

                if (rowId == null || rowId.trim().isEmpty() || "\\N".equals(rowId) || "\\\\N".equals(rowId)) {
                    continue;  // Skip null, empty or \N and \\N values
                }

                // Create mutation for a row of a relational db, will contain #columns total mutations
                Mutation m = new Mutation(rowId);
                for (int i = 0; i < columns.size(); i++) {
                    String fieldVal = fields[i];
                    String columnType = columnTypes.get(i);

                    if (fieldVal == null || fieldVal.trim().isEmpty() || "\\N".equals(fieldVal) || "\\\\N".equals(fieldVal)) {
                        continue;  // Skip null, empty or \N and \\N values
                    }

                    // Check the column type and convert if needed -> only used for dbgen_version
                    switch (columnType.toLowerCase()) {
                        case "date" -> fieldVal = String.valueOf(dateFormat.convertDateToAccumuloFormat(fieldVal));
                        case "time" -> fieldVal = String.valueOf(timeFormat.convertTimeToPicoseconds(fieldVal));
                    }

                    String columnName = columns.get(i);
                    m.put(new Text(columnName), new Text(columnName), new Value(fieldVal.getBytes()));
                }

                writer.addMutation(m);
                rowCount++;
            }

            return rowCount;

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
