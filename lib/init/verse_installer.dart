import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

List<dynamic> hanOriginalList = [];
List<dynamic> hanRawList = [];
List<dynamic> gaeOriginalList = [];
List<dynamic> gaeRawList = [];
List<dynamic> cevOriginalList = [];
List<dynamic> cevRawList = [];
List<dynamic> kjvOriginalList = [];
List<dynamic> kjvRawList = [];

readBibleFileHAN() async {
  //han
  final originalData =
      await rootBundle.loadString("assets/bibles/HAN_original.csv");
  final rawData = await rootBundle.loadString("assets/bibles/HAN_raw.csv");
  final orgList = const CsvToListConverter().convert(originalData);
  final rawList = const CsvToListConverter().convert(rawData);

  hanOriginalList = formatBible(orgList);
  hanRawList = formatBible(rawList);
}

readBibleFileGAE() async {
  //gae
  final originalData =
      await rootBundle.loadString("assets/bibles/GAE_original.csv");
  final rawData = await rootBundle.loadString("assets/bibles/GAE_raw.csv");
  final orgList = const CsvToListConverter().convert(originalData);
  final rawList = const CsvToListConverter().convert(rawData);

  gaeOriginalList = formatBible(orgList);
  gaeRawList = formatBible(rawList);
}

readBibleFileCEV() async {
  //cev
  final originalData =
      await rootBundle.loadString("assets/bibles/CEV_original.csv");
  final rawData = await rootBundle.loadString("assets/bibles/CEV_raw.csv");
  final orgList = const CsvToListConverter().convert(originalData);
  final rawList = const CsvToListConverter().convert(rawData);

  cevOriginalList = formatBible(orgList);
  cevRawList = formatBible(rawList);
}

readBibleFileKJV() async {
  //kjv
  final originalData =
      await rootBundle.loadString("assets/bibles/KJV_original.csv");
  final rawData = await rootBundle.loadString("assets/bibles/KJV_raw.csv");
  final orgList = const CsvToListConverter().convert(originalData);
  final rawList = const CsvToListConverter().convert(rawData);

  kjvOriginalList = formatBible(orgList);
  kjvRawList = formatBible(rawList);
}

List<dynamic> formatBible(List list) {
  List<dynamic> resList = [];
  List<List<dynamic>> chapterList = [];
  for (var l in list) {
    int index = l[2];
    if (index == 0 && l != list.first) {
      // if verse number is 0
      resList.add(chapterList);
      chapterList = [];
    }

    chapterList.add(l);
  }

  resList.add(chapterList);
  return resList;
}
