import 'package:bible/main.dart';
import 'package:bible/provider/list.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/widgets/page_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

showTypeSetterDialog(context) {
  showDialog(
    context: context,
    //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
    builder: (context) {
      return Dialog(
        // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Consumer<CurrentBible>(
          builder: (context, currentBible, child) {
            return SizedBox(
              width: 320,
              height: 320,
              child: ListView.builder(
                itemCount: bookTypeList.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      Navigator.pop(context);

                      currentBible.setBibleVersion(bookTypeList[index]);
                      //print(currentBible.curBook[currentBible.lbindex][0][1]);
                    },
                    child: Text(
                      bookTypeList[index],
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  );
                },
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
        // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
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
                    const TabBar(tabs: [
                      SizedBox(
                        height: 64,
                        child: Center(
                          child: Text(
                            'Old',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 64,
                        child: Center(
                          child: Text(
                            'New',
                            style: TextStyle(fontSize: 32),
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
                              crossAxisCount: 4,
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
                                    child: Text(
                                      curBookList[title],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.count(
                              crossAxisCount: 4,
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
                                    child: Text(
                                      curBookList[39 + title],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
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
    //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
    builder: (context) {
      return Dialog(
        // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Consumer<CurrentBible>(
          builder: (context, currentBible, child) {
            return SizedBox(
              width: 320,
              height: 640,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 4,
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
                          Navigator.pop(context);

                          currentBible.setPageWithTS(
                              currentBible.lastBibleTitle, chapter);
                        },
                        child: Text(
                          '${chapter + 1}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
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
