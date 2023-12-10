package com.accumulopop;

import java.util.List;

public record TableSchema(List<String> columns, List<String> columnTypes) {
}
