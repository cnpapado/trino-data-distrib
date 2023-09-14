package com.accumulopop;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TableStructureExtractor {

    public static TableSchema getColumns(String dataSchemaPath, String tableName) {
        List<String> columns = new ArrayList<>();
        List<String> columnTypes = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(dataSchemaPath))) {
            StringBuilder contentBuilder = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                contentBuilder.append(line).append("\n");
            }
            String content = contentBuilder.toString();
            Pattern pattern = Pattern.compile("create table " + tableName + "\\s*\\(([^;]*)\\);", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
            Matcher matcher = pattern.matcher(content);

            if (matcher.find()) {
                String tableContent = matcher.group(1).trim();
                for (String columnLine : tableContent.split("\n")) {
                    if (!columnLine.trim().toLowerCase().startsWith("primary key") && !columnLine.trim().startsWith(",")) {
                        String[] parts = columnLine.trim().split("\\s+");
                        columns.add(parts[0]);
                        columnTypes.add(parts[1]);
                    }
                }
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return new TableSchema(columns, columnTypes);
    }
}
