package com.yourcompany;

import java.util.ArrayList;
import java.util.regex.*;
import java.nio.file.*;
import java.io.IOException;
import java.util.List;

public class SchemaReader {
    public static String findPKTags(String dataSchemaPath, String tableName) throws IOException {
        String content = new String(Files.readAllBytes(Paths.get(dataSchemaPath)));
        Pattern pattern = Pattern.compile("create table " + tableName + "\\s*\\(([^;]*)\\);", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
        Matcher matcher = pattern.matcher(content);

        if (matcher.find()) {
            String tableContents = matcher.group(1);
            String[] lines = tableContents.trim().split("\\n");

            // Extract primary_key
            String pkLine = lines[lines.length - 1];
            Matcher pkMatcher = Pattern.compile("\\(([^)]*)\\)").matcher(pkLine);
//            pkMatcher.find();
            String primaryKey = pkMatcher.group(1);

            // Extract column tags
            List<String> columnTags = new ArrayList<>();
            for (int i = 0; i < lines.length - 1; i++) {
                String line = lines[i].trim();
                if (!line.toLowerCase().startsWith("primary key")) {
                    columnTags.add(line.split("\\s")[0]);
                }
            }

            // Return combined data, or any structure you like
            return primaryKey + " " + String.join(", ", columnTags);
        }
        return "Not found";
    }
}
