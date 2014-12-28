class Data {
  
  int rowCount;
  String[][] data;
  
  Data(String filename) {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];
    
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      
      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      
      // copy to the table array
      data[rowCount] = pieces;
      rowCount++;
    }
    
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }
  
  int getRowCount() {
    return rowCount;
  } 
  
}
