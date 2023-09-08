package com.yourcompany;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TableStructureExtractor {

    public static List<String> getColumns(String dataSchemaPath, String tableName) {
        List<String> columns = new ArrayList<>();

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
                        columns.add(columnLine.trim().split("\\s")[0]);
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("Exception Found!");
            // Properly handle exception in production scenarios.
        }

        return columns;
    }
}
