import 'dart:convert';
import 'dart:typed_data';

import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

Future<List> getDictionary(String toSearch) async {
  String xmlString = await makeRequest(_utf8(toSearch));
  if (xmlString == '') {
    return [];
  }
  XmlDocument xmlData = XmlDocument.parse(xmlString);
  final itemData = xmlData.findAllElements('item');
  List urlList = [];

  for (var id in itemData) {
    var titleElement = id.getElement('title');
    var linkElement = id.getElement('link');
    var descriptionElement = id.getElement('description');

    String title = titleElement!.innerText;
    String link = linkElement!.innerText;
    String description = descriptionElement!.innerText;

    if (!link.contains('categoryId=51387')) {
      continue;
    }
    title = title.replaceAll('<b>', '');
    title = title.replaceAll('</b>', '');
    description = description.replaceAll('<b>', '');
    description = description.replaceAll('</b>', '');
    urlList.add([title, link, description]);
  }

  return urlList;
}

String _utf8(String toSearch) {
  Utf8Encoder encoder = const Utf8Encoder();
  Uint8List encoded = encoder.convert(toSearch);

  var res = encoded.map((e) => '%${e.toRadixString(16)}').toList().join();

  return res;
}

Future<String> makeRequest(String utf8) async {
  var uri = Uri.parse(
    'https://openapi.naver.com/v1/search/encyc.xml?query=$utf8&display=100&start=1&sort=sim',
  );

  var response = await http.get(uri, headers: {
    'X-Naver-Client-Id': '3fQj4POHltDI0sWljvDk',
    'X-Naver-Client-Secret': 'gnRXuaH7E_'
  });

  //print(response.body);
  //If the http request is successful the statusCode will be 200
  if (response.statusCode == 200) {
    String htmlToParse = response.body;
    return htmlToParse;
  }
  return '';
}
