//package com.yourcompany;
//
//import java.util.Properties;
//import java.io.FileInputStream;
//import java.io.InputStream;
//import java.io.IOException;
//
//public class ConfigReader {
//    private final Properties prop;
//
//    public ConfigReader(String filePath) throws IOException {
//        prop = new Properties();
//        try (InputStream stream = new FileInputStream(filePath)) {
//            prop.load(stream);
//        } catch (IOException e) {
//            // If direct file read failed, try to load as a resource from classpath
//            try (InputStream resourceStream = this.getClass().getClassLoader().getResourceAsStream(filePath)) {
//                if (resourceStream == null) {
//                    throw new IOException("Failed to load configuration as a resource.");
//                }
//                prop.load(resourceStream);
//            }
//        }
//    }
//
//    public String get(String key) {
//        return prop.getProperty(key);
//    }
//}
