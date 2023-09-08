package com.mycompany;

import org.apache.accumulo.core.data.Key;
import org.apache.accumulo.core.data.Value;
import org.apache.accumulo.core.file.FileOperations;
import org.apache.accumulo.core.file.rfile.RFile;
import org.apache.accumulo.core.conf.AccumuloConfiguration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.conf.Configuration;

public class RFileCreator {
    public static void main(String[] args) throws Exception {
        // Define the output path for the RFile
        Path outputPath = new Path("file.rf");
        FileSystem fs = FileSystem.get(new Configuration());
        RFile.Writer writer = (RFile.Writer) FileOperations.getInstance().newWriterBuilder()
                .forFile(outputPath.toString(), fs, fs.getConf())
                .withTableConfiguration(AccumuloConfiguration.getDefaultConfiguration())
                .build();
        writer.startDefaultLocalityGroup();

        // Sample data
        String[][] data = {
                {"row1", "colfam1", "colqual1", "value1"},
                {"row2", "colfam2", "colqual2", "value2"}
        };

        for (String[] entry : data) {
            Key key = new Key(new Text(entry[0]), new Text(entry[1]), new Text(entry[2]));
            Value value = new Value(entry[3].getBytes());
            writer.append(key, value);
        }

        // Close the writer when done
        writer.close();
    }
}
