import 'package:bible/main.dart';
import 'package:bible/provider/list.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/screens/copy_screen.dart';
import 'package:bible/widgets/verse_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerseScreen extends StatefulWidget {
  const VerseScreen({super.key});

  @override
  State<VerseScreen> createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  int _selectedOnMenu = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ColorScheme colorScheme = themeData.colorScheme;

    return Scaffold(
      key: _key,
      extendBody: true,
      appBar: buildAppBar(_key, theme: themeData.appBarTheme),
      endDrawer: buildDrawer(colorScheme),
      backgroundColor: themeData.scaffoldBackgroundColor,
      body: const VerseBuilder(),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  Widget buildDrawer(ColorScheme colorScheme) {
    return Drawer(
      backgroundColor: colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: const Center(
              child: Text(
                '내가 진실로 속히 오리라 하시거늘\n\n아멘 주 예수여 오시옵소서',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          _buildMenuListTile("인명 사전 (미완)", 0),
          _buildMenuListTile("지명 사전 (미완)", 1),
          _buildMenuListTile("지도 (미완)", 2),
          _buildMenuListTile("단위 (미완)", 3),
          const Divider(
            thickness: 4,
          ),
          _buildMenuListTile("화면 설정", 4),
        ],
      ),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedOnMenu = index;
    });
  }

  Widget _buildMenuListTile(String content, int number) {
    return ListTile(
      title: Text(
        content,
        style: const TextStyle(fontSize: 16),
      ),
      selected: _selectedOnMenu == number,
      onTap: () {
        // Update the state of the app
        _onItemTapped(number);
        // Then close the drawer
      },
    );
  }

  buildAppBar(key, {required AppBarTheme theme}) {
    return AppBar(
      centerTitle: true,
      backgroundColor: theme.backgroundColor,
      title: Consumer<CurrentBible>(
        builder: (context, currentBible, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    buildTitleDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32,
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Text(
                      bookListKor[currentBible.lbt].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    buildChapterDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32,
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Text(
                      '- ${currentBible.lbc} -',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     buildTypeDialog(context);
                //   },
                //   child: Container(
                //     alignment: Alignment.center,
                //     height: 32,
                //     decoration: const BoxDecoration(
                //         border:
                //             Border(bottom: BorderSide(color: Colors.white))),
                //     child: Text(
                //       currentBible.bt,
                //       style: const TextStyle(
                //         fontSize: 16,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  key.currentState?.openEndDrawer();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildBottomAppBar() {
    return BottomAppBar(
      height: 128,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                CopyScreen.openCopyScreen(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shadowColor: Colors.black,
                backgroundColor: CustomThemeData.colorScheme.background,
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.black26)),
              ),
              child: Icon(Icons.check,
                  size: 32, color: CustomThemeData.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  buildTitleDialog(context) {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Consumer<CurrentBible>(
            builder: (context, currentBible, child) {
              return SizedBox(
                width: 320,
                height: 680,
                child: Column(
                  children: [
                    SizedBox(
                      width: 320,
                      height: 320,
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2,
                        children: List.generate(
                          39,
                          (title) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CustomThemeData.colorScheme.primary),
                              onPressed: () {
                                Navigator.pop(context);

                                currentBible.setPageWithCS(title, 1);
                                VerseBuilder.pageController
                                    .jumpToPage(currentBible.lbindex);
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
                    const Divider(
                      thickness: 8,
                    ),
                    SizedBox(
                      width: 320,
                      height: 320,
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2,
                        children: List.generate(
                          27,
                          (title) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                Navigator.pop(context);

                                currentBible.setPageWithCS(39 + title, 1);
                                VerseBuilder.pageController
                                    .jumpToPage(currentBible.lbindex);
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
              );
            },
          ),
        );
      },
    );
  }

  buildChapterDialog(context) {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Consumer<CurrentBible>(
            builder: (context, currentBible, child) {
              return SizedBox(
                width: 320,
                height: 680,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2,
                  children: List.generate(
                    chapterList[currentBible.lbt],
                    (chapter) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          Navigator.pop(context);

                          currentBible.setPageWithCS(
                              currentBible.lbt, chapter + 1);
                          VerseBuilder.pageController
                              .jumpToPage(currentBible.lbindex);
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
              );
            },
          ),
        );
      },
    );
  }

  buildTypeDialog(context) {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Consumer<CurrentBible>(
            builder: (context, currentBible, child) {
              return SizedBox(
                width: 320,
                height: 320,
                child: ListView.builder(
                  itemCount: bookTypeList.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        Navigator.pop(context);

                        currentBible.setBt(bookTypeList[index]);
                        //print(currentBible.curBook[currentBible.lbindex][0][1]);
                      },
                      child: Text(
                        bookTypeList[index],
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
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
}
