package com.accumulopop;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class dateFormat {

    public static int convertDateToAccumuloFormat(String dateString) {
        // Define the epoch start as 1970-01-01
        LocalDate epochStart = LocalDate.of(1970, 1, 1);

        // Parse the date string
        LocalDate date = LocalDate.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        // Calculate the number of days between the date string and the Unix epoch date

        return (int) ChronoUnit.DAYS.between(epochStart, date);
    }
}
