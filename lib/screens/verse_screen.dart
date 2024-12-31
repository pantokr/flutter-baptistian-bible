import 'package:flutter_baptistian_bible/provider/provider.dart';
import 'package:flutter_baptistian_bible/screens/copy_screen.dart';
import 'package:flutter_baptistian_bible/screens/dic_search_screen.dart';
import 'package:flutter_baptistian_bible/screens/map_screen.dart';
import 'package:flutter_baptistian_bible/screens/memo_screen.dart';
import 'package:flutter_baptistian_bible/screens/search_screen.dart';
import 'package:flutter_baptistian_bible/theme/theme.dart';
import 'package:flutter_baptistian_bible/widgets/dialog.dart';
import 'package:flutter_baptistian_bible/widgets/page_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerseScreen extends StatefulWidget {
  const VerseScreen({super.key});

  @override
  State<VerseScreen> createState() => _VerseScreenState();
}

class _VerseScreenState extends State<VerseScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      extendBody: true,
      appBar: buildAppBar(_key),
      endDrawer: buildDrawer(),
      body: const PageBuilder(),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: CustomThemeData.color1,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: CustomThemeData.colorScheme.primary,
            ),
            child: const Center(
              child: Text(
                '내가 진실로 속히 오리라 하시거늘\n아멘 주 예수여 오시옵소서',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          buildMenuListTile("사전", 0),
          buildMenuListTile("지도", 1),
          //buildMenuListTile("단위 (미완)", 2),
          const Divider(
            thickness: 4,
          ),
          buildMenuListTile("저장된 말씀", 2),
          buildMenuListTile("화면 설정", 3),
          buildMenuListTile("번역본 설정", 4),
        ],
      ),
    );
  }

  buildMenuListTile(String content, int number) {
    return ListTile(
      title: Text(
        content,
        style: TextStyle(fontSize: 16, color: CustomThemeData.textColor),
      ),
      onTap: () {
        _key.currentState?.closeEndDrawer();
        if (number == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const DicSearchScreen();
              },
            ),
          );
        }
        if (number == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MapScreen();
              },
            ),
          );
        }
        if (number == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const MemoScreen();
              },
            ),
          );
        }
        if (number == 3) {
          showChangeThemeDialog(context);
        }
        if (number == 4) {
          showTypeSetterDialog(context);
        }
      },
    );
  }

  buildAppBar(
    key,
  ) {
    return AppBar(
      centerTitle: true,
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
                    showTitleDialog(context, currentBible.curTitleList);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32,
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Text(
                      currentBible.curTitleList[currentBible.lastBibleTitle]
                          .toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showChapterDialog(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32,
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Text(
                      '- ${currentBible.lastBibleChapter + 1} -',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
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
                openCopyScreen(context, []);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shadowColor: Colors.black,
                backgroundColor: CustomThemeData.color1,
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.black26)),
              ),
              child: Icon(Icons.border_color,
                  size: 32, color: CustomThemeData.colorScheme.primary),
            ),
          ),
          SizedBox(
            width: 64,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                openSearchScreen(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shadowColor: Colors.black,
                backgroundColor: CustomThemeData.color1,
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.black26)),
              ),
              child: Icon(Icons.search,
                  size: 32, color: CustomThemeData.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
