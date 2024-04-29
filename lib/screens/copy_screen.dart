import 'package:bible/provider/provider.dart';
import 'package:bible/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CopyScreen extends StatefulWidget {
  final List chapter;
  final List initialVerse;
  const CopyScreen(
      {super.key, required this.chapter, required this.initialVerse});

  @override
  State<CopyScreen> createState() => _CopyScreenState();
}

class _CopyScreenState extends State<CopyScreen> {
  late final List<dynamic> chapter;
  late final List<dynamic> initialVerse;

  List selectedVerses = [];
  Color boxColor = Colors.grey;
  AutoScrollController copyController = AutoScrollController();

  @override
  void initState() {
    chapter = widget.chapter;
    initialVerse = widget.initialVerse;
    // ListBuilder.scrollToVerse(initialVerse);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (initialVerse.isNotEmpty) {
          copyController.scrollToIndex(initialVerse[2],
              duration: const Duration(microseconds: 1000),
              preferPosition: AutoScrollPosition.middle);

          _selectBox(chapter[initialVerse[2]]);
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    copyController.dispose();
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
              '선택',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          controller: copyController,
          itemCount: chapter.length,
          itemBuilder: (context, verseIndex) {
            return AutoScrollTag(
                key: ValueKey(verseIndex),
                controller: copyController,
                index: verseIndex,
                child: buildSelectableRawContent(chapter[verseIndex]));
          },
        ),
      ),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  buildSelectableRawContent(List<dynamic> verse) {
    return InkWell(
      onTap: () {
        _selectBox(verse);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Container(
          decoration: BoxDecoration(
            color: selectedVerses.contains(verse)
                ? boxColor
                : CustomThemeData.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 40,
                  child: Text(
                    verse[3].toString(),
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 16),
                  )),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: buildWrappedString(verse[4]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildWrappedString(String str) {
    List<String> parsedSec = str.trim().split(' ');

    return Wrap(
      children: parsedSec
          .map<Widget>(
            (text) => Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
          .toList(),
    );
  }

  _selectBox(verse) {
    if (selectedVerses.contains(verse)) {
      selectedVerses.remove(verse);
    } else {
      selectedVerses.add(verse);
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
    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        return SizedBox(
          width: 64,
          height: 64,
          child: ElevatedButton(
            onPressed: () {
              if (selectedVerses.isEmpty) {
                showToast('선택된 절이 없습니다');
              } else {
                String title =
                    '${currentBible.curTitleList[chapter[0][0]]} ${chapter[0][1] + 1}\n\n';
                String body = '';
                for (var text in selectedVerses) {
                  String line = '${text[3]} ${text[4]}\n';
                  body += line;
                }
                String total = title + body;
                Clipboard.setData(ClipboardData(text: total));
                showToast('말씀이 복사되었습니다');
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 8,
              shadowColor: Colors.black,
              backgroundColor: CustomThemeData.color1,
              shape:
                  const CircleBorder(side: BorderSide(color: Colors.black26)),
            ),
            child: Icon(Icons.copy,
                size: 32, color: CustomThemeData.colorScheme.primary),
          ),
        );
      },
    );
  }

  _buildSelectAllButton() {
    return SizedBox(
      width: 64,
      height: 64,
      child: ElevatedButton(
        onPressed: () {
          if (selectedVerses.length == chapter.length) {
            for (var verse in chapter) {
              _selectBox(verse);
            }
          } else {
            selectedVerses.clear();
            for (var verse in chapter) {
              _selectBox(verse);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shadowColor: Colors.black,
          backgroundColor: CustomThemeData.color1,
          shape: const CircleBorder(side: BorderSide(color: Colors.black26)),
        ),
        child: Icon(Icons.select_all,
            size: 32, color: CustomThemeData.colorScheme.primary),
      ),
    );
  }

  _buildAppendMemoButton() {
    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        return SizedBox(
          width: 64,
          height: 64,
          child: ElevatedButton(
            onPressed: () {
              if (selectedVerses.isEmpty) {
                showToast('선택된 절이 없습니다');
              } else {
                String title = '${currentBible.curRawBook.indexOf(chapter)}';
                String body = '';
                for (var text in selectedVerses) {
                  String line = ':${text[3]}';
                  body += line;
                }
                String total = title + body;
                currentBible.addMemoList(total);
                showToast('말씀이 저장되었습니다');
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 8,
              shadowColor: Colors.black,
              backgroundColor: CustomThemeData.color1,
              shape:
                  const CircleBorder(side: BorderSide(color: Colors.black26)),
            ),
            child: Icon(Icons.note_add,
                size: 32, color: CustomThemeData.colorScheme.primary),
          ),
        );
      },
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

openCopyScreen(context, initialVerse) {
  CurrentBible currentBible = Provider.of<CurrentBible>(context, listen: false);
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CopyScreen(
        chapter: currentBible.curRawBook[currentBible.lastBibleIndex],
        initialVerse: initialVerse,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 1.0);
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
