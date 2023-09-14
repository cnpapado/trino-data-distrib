package com.accumulopop;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class timeFormat {

    public static long convertTimeToPicoseconds(String timeString) {
        // Parse the time string
        DateTimeFormatter formatter;

        // Check if the timeString has milliseconds
        if (timeString.length() > 8) {
            formatter = DateTimeFormatter.ofPattern("HH:mm:ss.SSS");
        } else {
            formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
        }

        LocalTime time = LocalTime.parse(timeString, formatter);
        long millis = time.toNanoOfDay() / 1_000_000; // Convert nanoseconds of the day to milliseconds

        // Convert milliseconds to picoseconds (multiply by 1 million)
        return millis *1_000_000_000L;
    }
}
