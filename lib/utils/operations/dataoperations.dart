List<String> mapData2List(data, key) {
  List<String> allDataListed = [];
  for (int i = 0; i <= data.length - 1; i++) {
    allDataListed.add(data[i][key].toString());
  }
  return allDataListed;
}
