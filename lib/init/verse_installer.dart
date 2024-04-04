import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

List<List<List<dynamic>>> hanOriginalList = [];
List<List<List<dynamic>>> hanRawList = [];
List<List<List<dynamic>>> gaeOriginalList = [];
List<List<List<dynamic>>> gaeRawList = [];

readBibleFileHAN() async {
  //han
  final originalData = await rootBundle.loadString("assets/HAN_original.csv");
  final rawData = await rootBundle.loadString("assets/HAN_raw.csv");
  var orgList = const CsvToListConverter().convert(originalData);
  var rawList = const CsvToListConverter().convert(rawData);

  hanOriginalList = formatBible(orgList);
  hanRawList = formatBible(rawList);
}

readBibleFileGAE() async {
  //gae
  final originalData = await rootBundle.loadString("assets/GAE_original.csv");
  final rawData = await rootBundle.loadString("assets/GAE_raw.csv");
  var orgList = const CsvToListConverter().convert(originalData);
  var rawList = const CsvToListConverter().convert(rawData);

  gaeOriginalList = formatBible(orgList);
  gaeRawList = formatBible(rawList);
}

List<List<List<dynamic>>> formatBible(list) {
  List<List<List<dynamic>>> resList = [];

  List<List<dynamic>> tList = [];
  for (var l in list) {
    String indstr = l[0].toString();
    if ((indstr == '1' || indstr == '1-2' || indstr == '1-3') && l != list[0]) {
      resList.add(tList);
      tList = [];
    }
    tList.add(l);
  }

  return resList;
}
