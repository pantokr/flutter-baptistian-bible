import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

getPref() async {
  pref = await SharedPreferences.getInstance();
  if (pref.getKeys().isEmpty) {
    pref.setString('lastBibleVersion', '개역한글');
    pref.setInt('lastBibleTitle', 0);
    pref.setInt('lastBibleChapter', 0);
    pref.setInt('lastBibleVerse', 0);
    pref.setInt('lastBibleIndex', 0);
    //pref.setString('lbtn', '창세기 1장');
  }
  // pref.clear();
  if (pref.getString('lastBibleVersion') == null) {
    pref.setString('lastBibleVersion', '개역한글');
  }
  if (pref.getInt('lastBibleTitle') == null) {
    pref.setInt('lastBibleTitle', 0);
  }
  if (pref.getInt('lastBibleChapter') == null) {
    pref.setInt('lastBibleChapter', 0);
  }
  if (pref.getInt('lastBibleVerse') == null) {
    pref.setInt('lastBibleVerse', 0);
  }
  if (pref.getInt('lastBibleIndex') == null) {
    pref.setInt('lastBibleIndex', 0);
  }
  // for (var element in pref.getKeys()) {
  //   print(pref.get(element));
  // }
}
