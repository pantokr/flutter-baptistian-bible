import 'package:bible/init/preference_manager.dart';
import 'package:bible/init/verse_installer.dart';
import 'package:bible/provider/list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bible/init/preference_manager.dart';

class CurrentBible with ChangeNotifier {
  CurrentBible() {
    _bt = pref.getString('bt')!;
    _lbt = pref.getInt('lbt')!;
    _lbc = pref.getInt('lbc')!;
    _lbindex = pref.getInt('lbindex')!;

    arrangeType(_bt);
  }

  List<dynamic> _curBook = [];
  List<dynamic> get curBook => _curBook;

  String _bt = '';
  String get bt => _bt;

  int _lbt = 0;
  int get lbt => _lbt;

  int _lbc = 1;
  int get lbc => _lbc;

  int _lbindex = 0;
  int get lbindex => _lbindex;

  void setBt(str) {
    _bt = str;
    pref.setString('bt', str);
    arrangeType(str);
    notifyListeners();
  }

  void setLbt(index) {
    _lbt = index;
    pref.setInt('lbt', index);
    notifyListeners();
  }

  void setLbc(index) {
    _lbc = index;
    pref.setInt('lbc', index);
    notifyListeners();
  }

  void setLbindex(index) {
    _lbindex = index;
    pref.setInt('lbindex', index);
    notifyListeners();
  }

  void setPage(index) {
    var firstSec = curBook[index][0];
    var bt = firstSec[2];
    var bc = firstSec[3];

    setLbt(bt);
    setLbc(bc);
    setLbindex(index);
    notifyListeners();
  }

  void setPageWithCS(int chp, int sec) {
    setLbt(chp);
    setLbc(sec);
    int sum = 0;
    for (int i = 0; i < chp; i++) {
      sum += chapterList[i];
    }
    sum += sec - 1;
    setLbindex(sum);
    notifyListeners();
  }

  void arrangeType(type) {
    if (type == '개역한글') {
      _han();
    } else if (type == '개역개정') {
      _gae();
    }
    notifyListeners();
  }

  void setAlternativeBibleMode() {
    _curBook =
        listEquals(_curBook, curOriginalBook) ? curRawBook : curOriginalBook;
    notifyListeners();
  }

  void _han() {
    curOriginalBook = hanOriginalList;
    curRawBook = hanRawList;
    _curBook = curOriginalBook;

    curBookList = bookListKor;
  }

  void _gae() {
    curOriginalBook = gaeOriginalList;
    curRawBook = gaeRawList;
    _curBook = curOriginalBook;

    curBookList = bookListKor;
  }
}
