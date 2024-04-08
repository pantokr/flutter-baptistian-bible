import 'package:bible/main.dart';
import 'package:bible/provider/list.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/screens/copy_screen.dart';
import 'package:bible/screens/search_screen.dart';
import 'package:bible/widgets/dialog.dart';
import 'package:bible/widgets/page_builder.dart';
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
      body: const PageBuilder(),
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
                '내가 진실로 속히 오리라 하시거늘\n아멘 주 예수여 오시옵소서',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          buildMenuListTile("인명 사전 (미완)", 0),
          buildMenuListTile("지명 사전 (미완)", 1),
          buildMenuListTile("지도 (미완)", 2),
          buildMenuListTile("단위 (미완)", 3),
          const Divider(
            thickness: 4,
          ),
          buildMenuListTile("화면 설정", 4),
        ],
      ),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedOnMenu = index;
    });
  }

  buildMenuListTile(String content, int number) {
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
                    showTitleDialog(context, currentBible.curTitleList);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 32,
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white))),
                    child: Text(
                      bookListKor[currentBible.lastBibleTitle].toString(),
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
                backgroundColor: CustomThemeData.colorScheme.background,
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
                _openSearchScreen(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8,
                shadowColor: Colors.black,
                backgroundColor: CustomThemeData.colorScheme.background,
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

  _openSearchScreen(context) {
    CurrentBible currentBible =
        Provider.of<CurrentBible>(context, listen: false);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }
}
