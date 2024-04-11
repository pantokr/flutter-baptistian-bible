import 'package:bible/init/preference_manager.dart';
import 'package:bible/init/verse_installer.dart';
import 'package:bible/provider/list.dart';
import 'package:bible/widgets/page_builder.dart';
import 'package:flutter/foundation.dart';

class CurrentBible with ChangeNotifier {
  CurrentBible() {
    _lastBibleVersion = pref.getString('lastBibleVersion')!;
    _lastBibleTitle = pref.getInt('lastBibleTitle')!;
    _lastBibleChapter = pref.getInt('lastBibleChapter')!;
    //_lastBibleVerse = pref.getInt('lastBibleVerse')!;
    _lastBibleIndex = pref.getInt('lastBibleIndex')!;
    _historyList = pref.getStringList('historyList')!;
    _memoList = pref.getStringList('memoList')!;

    arrangeType(_lastBibleVersion);
  }

  List<dynamic> _curOriginalBook = [];
  List<dynamic> get curOriginalBook => _curOriginalBook;

  List<dynamic> _curRawBook = [];
  List<dynamic> get curRawBook => _curRawBook;

  List<dynamic> _curTitleList = [];
  List<dynamic> get curTitleList => _curTitleList;

  List<dynamic> _curTitleListShort = [];
  List<dynamic> get curTitleListShort => _curTitleListShort;

  String _lastBibleVersion = '';
  String get lastBibleVersion => _lastBibleVersion;

  int _lastBibleTitle = 0;
  int get lastBibleTitle => _lastBibleTitle;

  int _lastBibleChapter = 0;
  int get lastBibleChapter => _lastBibleChapter;

  // int _lastBibleVerse = 0;
  // int get lastBibleVerse => _lastBibleVerse;

  int _lastBibleIndex = 0;
  int get lastBibleIndex => _lastBibleIndex;

  List<String> _historyList = [];
  List<String> get historyList => _historyList;

  List<String> _memoList = [];
  List<String> get memoList => _memoList;

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

  // void setLastBibleVerse(verseIndex) {
  //   _lastBibleVerse = verseIndex;
  //   pref.setInt('lastBibleVerse', verseIndex);
  //   notifyListeners();
  // }

  void setLastbibleIndex(totalIndex) {
    _lastBibleIndex = totalIndex;
    pref.setInt('lastBibleIndex', totalIndex);
    notifyListeners();
  }

  void addHistoryList(chapterIndex, verseIndex) {
    String toStore = '$chapterIndex:$verseIndex';
    _historyList.remove(toStore);
    _historyList.add(toStore);
    if (_historyList.length >= 10) {
      _historyList.removeAt(0);
    }
    pref.setStringList('historyList', _historyList);
    //print(pref.getStringList('historyList'));
    notifyListeners();
  }

  void addMemoList(String verses) {
    _memoList.add(verses);
    pref.setStringList('memoList', _memoList);
    //print(pref.getStringList('historyList'));
    notifyListeners();
  }

  void deleteMemoList(int index) {
    _memoList.removeAt(index);

    pref.setStringList('memoList', _memoList);
    //print(pref.getStringList('historyList'));
    notifyListeners();
  }

  void setPage(pageIndex) {
    var firstSec = curOriginalBook[pageIndex][0];
    var bibleTitle = firstSec[0];
    var bibleChapter = firstSec[1];

    setLastBibleTitle(bibleTitle);
    setLastBibleChapter(bibleChapter);
    setLastbibleIndex(pageIndex);

    //print('$_lastBibleTitle $lastBibleChapter $lastBibleIndex');
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
    PageBuilder.jumpToPage(sum);
    //print('$titleIndex $chapterIndex $sum');
    notifyListeners();
  }

  void arrangeType(type) {
    if (type == '개역한글') {
      _han();
    } else if (type == '개역개정') {
      _gae();
    } else if (type == 'CEV') {
      _cev();
    } else if (type == 'KJV') {
      _kjv();
    } else {
      _han();
    }
    notifyListeners();
  }

  void _han() {
    _curOriginalBook = hanOriginalList;
    _curRawBook = hanRawList;
    _curTitleList = titleListKor;
    _curTitleListShort = titleListKorShort;
  }

  void _gae() {
    _curOriginalBook = gaeOriginalList;
    _curRawBook = gaeRawList;
    _curTitleList = titleListKor;
    _curTitleListShort = titleListKorShort;
  }

  void _cev() {
    _curOriginalBook = cevOriginalList;
    _curRawBook = cevRawList;
    _curTitleList = titleListEng;
    _curTitleListShort = titleListEngShort;
  }

  void _kjv() {
    _curOriginalBook = kjvOriginalList;
    _curRawBook = kjvRawList;
    _curTitleList = titleListEng;
    _curTitleListShort = titleListEngShort;
  }
}
