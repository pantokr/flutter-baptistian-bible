import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

getPref() async {
  pref = await SharedPreferences.getInstance();
  if (pref.getKeys().isEmpty) {
    pref.setString('bt', '개역한글');
    pref.setInt('lbt', 0);
    pref.setInt('lbc', 1);
    pref.setInt('lbindex', 0);
    //pref.setString('lbtn', '창세기 1장');
  }
  if (pref.getString('bt') == null) {
    pref.setString('bt', '개역한글');
  }
  if (pref.getInt('lbt') == null) {
    pref.setInt('lbt', 0);
  }
  if (pref.getInt('lbc') == null) {
    pref.setInt('lbc', 1);
  }
  if (pref.getInt('lbindex') == null) {
    pref.setInt('lbindex', 0);
  }
  // for (var element in pref.getKeys()) {
  //   print(pref.get(element));
  // }
}
