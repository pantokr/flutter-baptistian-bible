import 'package:bible/main.dart';
import 'package:bible/provider/list.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/widgets/verse_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CopyScreen extends StatefulWidget {
  final chapter;
  final initialSec;
  const CopyScreen({super.key, required this.chapter, this.initialSec});

  @override
  State<CopyScreen> createState() => _CopyScreenState();

  static openCopyScreen(context) {
    CurrentBible currentBible =
        Provider.of<CurrentBible>(context, listen: false);
    currentBible.setAlternativeBibleMode();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CopyScreen(chapter: currentBible.curBook[currentBible.lbindex]),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
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

class _CopyScreenState extends State<CopyScreen> {
  late final List<dynamic> chapter;
  late final int initialSec;

  List selectedVerses = [];
  Color boxColor = Colors.black12;

  @override
  void initState() {
    chapter = widget.chapter;
    initialSec = widget.initialSec ?? -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '선택하기',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Provider.of<CurrentBible>(context, listen: false)
                  .setAlternativeBibleMode();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Consumer<CurrentBible>(
        builder: (context, currentBible, child) {
          return ListView.builder(
            itemCount: chapter.length,
            itemBuilder: (context, sec) {
              return _buildContent(chapter[sec]);
            },
          );
        },
      ),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  Widget _buildContent(List<dynamic> sec) {
    return InkWell(
      onTap: () {
        _selectBox(sec);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: selectedVerses.contains(sec)
                ? boxColor
                : CustomThemeData.colorScheme.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 32,
                  child: Text(
                    sec[0].toString(),
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 16),
                  )),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: sec[1].toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectBox(sec) {
    if (selectedVerses.contains(sec)) {
      selectedVerses.remove(sec);
    } else {
      selectedVerses.add(sec);
      selectedVerses.sort(
        (a, b) {
          return chapter.indexOf(a) < chapter.indexOf(b) ? -1 : 1;
        },
      );
    }
    setState(() {});
  }

  buildBottomAppBar() {
    return BottomAppBar(
      height: 128,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCopyButton(),
          _buildSelectAllButton(),
          _buildAppendMemoButton()
        ],
      ),
    );
  }

  _buildCopyButton() {
    return SizedBox(
      width: 64,
      height: 64,
      child: ElevatedButton(
        onPressed: () {
          if (selectedVerses.isEmpty) {
            showToast('선택된 절이 없습니다');
          } else {
            String title = '${curBookList[chapter[0][2]]} ${chapter[0][3]}\n\n';
            String body = '';
            for (var text in selectedVerses) {
              String line = '${text[0]} ${text[1]}\n';
              body += line;
            }
            String total = title + body;
            Clipboard.setData(ClipboardData(text: total));
            showToast('클립보드에 복사되었습니다');
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black,
          backgroundColor: CustomThemeData.colorScheme.background,
          shape: const CircleBorder(side: BorderSide(color: Colors.black26)),
        ),
        child: Icon(Icons.copy,
            size: 32, color: CustomThemeData.colorScheme.primary),
      ),
    );
  }

  _buildSelectAllButton() {
    return SizedBox(
      width: 64,
      height: 64,
      child: ElevatedButton(
        onPressed: () {
          if (selectedVerses.length == chapter.length) {
            for (var sector in chapter) {
              _selectBox(sector);
            }
          } else {
            selectedVerses.clear();
            for (var sector in chapter) {
              _selectBox(sector);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black,
          backgroundColor: CustomThemeData.colorScheme.background,
          shape: const CircleBorder(side: BorderSide(color: Colors.black26)),
        ),
        child: Icon(Icons.select_all,
            size: 32, color: CustomThemeData.colorScheme.primary),
      ),
    );
  }

  _buildAppendMemoButton() {
    return SizedBox(
      width: 64,
      height: 64,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black,
          backgroundColor: CustomThemeData.colorScheme.background,
          shape: const CircleBorder(side: BorderSide(color: Colors.black26)),
        ),
        child: Icon(Icons.note_add,
            size: 32, color: CustomThemeData.colorScheme.primary),
      ),
    );
  }

  void showToast(content) {
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT, // 토스트 뜨는 시간 얼마나 길게 할 지 (Android)
      gravity: ToastGravity.BOTTOM, // 토스트 위치 어디에 할 것인지
      timeInSecForIosWeb: 1, // 토스트 뜨는 시간 얼마나 길게 할 지 (iOS & Web)
      backgroundColor: Colors.orange,
      textColor: Colors.grey,
      fontSize: 20.0,
    );
  }
}
