import 'package:flutter_baptistian_bible/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

getPref() async {
  pref = await SharedPreferences.getInstance();

  if (pref.getString('lastBibleVersion') == null) {
    pref.setString('lastBibleVersion', '개역한글');
  }
  if (pref.getInt('lastBibleTitle') == null) {
    pref.setInt('lastBibleTitle', 0);
  }
  if (pref.getInt('lastBibleChapter') == null) {
    pref.setInt('lastBibleChapter', 0);
  }
  if (pref.getInt('lastBibleIndex') == null) {
    pref.setInt('lastBibleIndex', 0);
  }
  if (pref.getStringList('historyList') == null) {
    pref.setStringList('historyList', []);
  }
  if (pref.getStringList('memoList') == null) {
    pref.setStringList('memoList', []);
  }
  if (pref.getBool('darkMode') == null) {
    pref.setBool('darkMode', false);
  }

  if ((pref.getBool('darkMode')!) != CustomThemeMode.current.value) {
    CustomThemeMode.change();
  }
}
