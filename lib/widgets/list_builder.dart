import 'package:bible/main.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/screens/copy_screen.dart';
import 'package:bible/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ListBuilder extends StatefulWidget {
  const ListBuilder({super.key});
  static AutoScrollController verseController = AutoScrollController();

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  Color boxColor = CustomThemeData.colorScheme.background;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        int chapterIndex = currentBible.lastBibleIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: ListView.builder(
            shrinkWrap: true,
            controller: ListBuilder.verseController,
            itemCount: currentBible.curOriginalBook[chapterIndex].length,
            itemBuilder: (context, verseIndex) {
              if (currentBible.curOriginalBook[chapterIndex][verseIndex][6] !=
                  '') {
                return buildOriginalContentWithSmallTitle(context,
                    currentBible.curOriginalBook[chapterIndex][verseIndex]);
              }
              return buildOriginalContent(context,
                  currentBible.curOriginalBook[chapterIndex][verseIndex]);
            },
          ),
        );
      },
    );
  }

  buildOriginalContent(
    context,
    List<dynamic> verse,
  ) {
    String verseContent = verse[4];

    Map<String, HighlightedWord> toHighlight = _toHighlight(context, verse);

    return AutoScrollTag(
      // key: ValueKey(verse[2]),
      key: UniqueKey(),
      controller: ListBuilder.verseController,
      index: verse[2],
      child: InkWell(
        onLongPress: () {
          openCopyScreen(context, verse);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              color: CustomThemeData.colorScheme.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 32,
                    child: Text(
                      verse[3].toString(),
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 16),
                    )),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: buildWrappedStringWithHighlight(
                        verseContent, toHighlight),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildOriginalContentWithSmallTitle(context, List<dynamic> verse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            verse[6].toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        buildOriginalContent(context, verse)
      ],
    );
  }

  buildWrappedStringWithHighlight(
      String str, Map<String, HighlightedWord> toHighlight) {
    List<String> parsedSec = str.trim().split(' ');
    if (parsedSec.last.isBlank!) {
      parsedSec.removeLast();
    }

    return Wrap(
      children: parsedSec
          .map<Widget>(
            (text) => Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: TextHighlight(text: text, words: toHighlight),
            ),
          )
          .toList(),
    );
  }

  _toHighlight(context, verse) {
    final re = RegExp('[1]?[ㄱ-ㅎ0-9][)]');
    var allMatches = re.allMatches(verse[4]);

    List<String> dscOrder = [];

    for (var matched in allMatches) {
      dscOrder.add(matched[0].toString());
    }
    List<String> descriptionList = verse[5].split('|');

    return {
      for (var matched in allMatches)
        matched[0].toString(): HighlightedWord(
          onTap: () {
            int index = dscOrder.indexOf(matched[0].toString());
            String description = descriptionList[index];
            showDescriptionDialog(context, description);
          },
          textStyle:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
    };
  }
}

initialScrollToVerse(int verseIndex) {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      ListBuilder.verseController
          .scrollToIndex(verseIndex, preferPosition: AutoScrollPosition.middle);
    },
  );
}
