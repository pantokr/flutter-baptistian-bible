import 'package:bible/init/preference_manager.dart';
import 'package:bible/provider/list.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

showTypeSetterDialog(context) {
  showDialog(
    context: context,
    //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
    builder: (context) {
      return Dialog(
        backgroundColor: CustomThemeData.color1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Consumer<CurrentBible>(
          builder: (context, currentBible, child) {
            return SizedBox(
              width: 320,
              height: 320,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: ListView.builder(
                    itemCount: bookTypeList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          Navigator.pop(context);

                          currentBible.setBibleVersion(bookTypeList[index]);
                          //print(currentBible.curBook[currentBible.lbindex][0][1]);
                        },
                        child: Text(
                          bookTypeList[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

showTitleDialog(context, curBookList) {
  showDialog(
    context: context,
    //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
    builder: (context) {
      return Dialog(
        backgroundColor: CustomThemeData.color1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Consumer<CurrentBible>(
          builder: (context, currentBible, child) {
            return DefaultTabController(
              length: 2,
              child: SizedBox(
                width: 320,
                height: 640,
                child: Column(
                  children: [
                    TabBar(tabs: [
                      SizedBox(
                        height: 64,
                        child: Center(
                          child: Text(
                            'Old',
                            style: TextStyle(
                                fontSize: 32,
                                color: CustomThemeData.colorScheme.primary),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 64,
                        child: Center(
                          child: Text(
                            'New',
                            style: TextStyle(
                                fontSize: 32,
                                color: CustomThemeData.colorScheme.primary),
                          ),
                        ),
                      ),
                    ]),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.6,
                              children: List.generate(
                                39,
                                (title) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: CustomThemeData
                                            .colorScheme.primary),
                                    onPressed: () {
                                      //print(title);
                                      Navigator.pop(context);

                                      currentBible.setPageWithTS(title, 0);
                                    },
                                    child: Center(
                                      child: Text(
                                        curBookList[title],
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.6,
                              children: List.generate(
                                27,
                                (title) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    onPressed: () {
                                      Navigator.pop(context);

                                      currentBible.setPageWithTS(39 + title, 0);
                                    },
                                    child: Center(
                                      child: Text(
                                        curBookList[39 + title],
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

showChapterDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: CustomThemeData.color1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Consumer<CurrentBible>(
          builder: (context, currentBible, child) {
            return SizedBox(
              width: 320,
              height: 640,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.6,
                  children: List.generate(
                    chapterLengthList[currentBible.lastBibleTitle],
                    (chapter) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          //print('${currentBible.lastBibleTitle} $chapter');
                          currentBible.setPageWithTS(
                              currentBible.lastBibleTitle, chapter);
                          Navigator.pop(context);
                        },
                        child: Text(
                          '${chapter + 1}',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

showDescriptionDialog(context, String description) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: CustomThemeData.color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: Text(
          description,
        ),
      );
    },
  );
}

showChangeThemeDialog(context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: CustomThemeData.color1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox(
          width: 320,
          height: 320,
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      Navigator.pop(context);
                      pref.setBool('darkMode', !CustomThemeMode.current.value);
                      Future.delayed(
                        const Duration(milliseconds: 500),
                        () {
                          CustomThemeMode.change();
                        },
                      );
                    },
                    child: const Text(
                      '다크모드 적용/해제',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
