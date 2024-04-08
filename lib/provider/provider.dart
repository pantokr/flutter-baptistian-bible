import 'package:bible/init/preference_manager.dart';
import 'package:bible/init/verse_installer.dart';
import 'package:bible/provider/list.dart';
import 'package:flutter/foundation.dart';

class CurrentBible with ChangeNotifier {
  CurrentBible() {
    _lastBibleVersion = pref.getString('lastBibleVersion')!;
    _lastBibleTitle = pref.getInt('lastBibleTitle')!;
    _lastBibleChapter = pref.getInt('lastBibleChapter')!;
    _lastBibleVerse = pref.getInt('lastBibleVerse')!;
    _lastBibleIndex = pref.getInt('lastBibleIndex')!;

    arrangeType(_lastBibleVersion);
  }

  List<dynamic> _curOriginalBook = [];
  List<dynamic> get curOriginalBook => _curOriginalBook;

  List<dynamic> _curRawBook = [];
  List<dynamic> get curRawBook => _curRawBook;

  List<dynamic> _curTitleList = [];
  List<dynamic> get curTitleList => _curTitleList;

  String _lastBibleVersion = '';
  String get lastBibleVersion => _lastBibleVersion;

  int _lastBibleTitle = 0;
  int get lastBibleTitle => _lastBibleTitle;

  int _lastBibleChapter = 0;
  int get lastBibleChapter => _lastBibleChapter;

  int _lastBibleVerse = 0;
  int get lastBibleVerse => _lastBibleVerse;

  int _lastBibleIndex = 0;
  int get lastBibleIndex => _lastBibleIndex;

  void setBibleVersion(str) {
    _lastBibleVersion = str;
    pref.setString('lastBibleVersion', str);
    arrangeType(str);
    notifyListeners();
  }

  void setLastBibleTitle(titleIndex) {
    _lastBibleTitle = titleIndex;
    pref.setInt('lastBibleTitle', titleIndex);
    notifyListeners();
  }

  void setLastBibleChapter(chapterIndex) {
    _lastBibleChapter = chapterIndex;
    pref.setInt('lastBibleChapter', chapterIndex);
    notifyListeners();
  }

  void setLastBibleVerse(verseIndex) {
    _lastBibleVerse = verseIndex;
    pref.setInt('lastBibleVerse', verseIndex);
    notifyListeners();
  }

  void setLastbibleIndex(totalIndex) {
    _lastBibleIndex = totalIndex;
    pref.setInt('lastBibleIndex', totalIndex);
    notifyListeners();
  }

  void setPage(pageIndex) {
    var firstSec = curOriginalBook[pageIndex][0];
    var bibleTitle = firstSec[0];
    var bibleChapter = firstSec[1];

    setLastBibleTitle(bibleTitle);
    setLastBibleChapter(bibleChapter);
    setLastbibleIndex(pageIndex);

    // print('$_lastBibleTitle $lastBibleChapter $lastBibleIndex');
    notifyListeners();
  }

  void setPageWithTS(int titleIndex, int chapterIndex) {
    setLastBibleTitle(titleIndex);
    setLastBibleChapter(chapterIndex);

    int sum = 0;
    for (int i = 0; i < titleIndex; i++) {
      sum += chapterLengthList[i];
    }
    sum += chapterIndex;

    setLastbibleIndex(sum);
    print('$titleIndex $chapterIndex $sum');
    notifyListeners();
  }

  void arrangeType(type) {
    if (type == '개역한글') {
      _han();
    } else if (type == '개역개정') {
      _gae();
    } else {
      _han();
    }
    notifyListeners();
  }

  void _han() {
    _curOriginalBook = hanOriginalList;
    _curRawBook = hanRawList;
    _curTitleList = bookListKor;
  }

  void _gae() {
    _curOriginalBook = gaeOriginalList;
    _curRawBook = gaeRawList;
    _curTitleList = bookListKor;
  }
}
