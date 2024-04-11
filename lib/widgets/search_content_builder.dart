import 'package:bible/provider/provider.dart';
import 'package:bible/theme/theme.dart';
import 'package:bible/widgets/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';

class SearchContentBuilder extends StatelessWidget {
  final context;
  final verse;
  final toSearch;

  const SearchContentBuilder({
    super.key,
    this.context,
    this.verse,
    this.toSearch,
  });

  @override
  Widget build(BuildContext context) {
    CurrentBible currentBible =
        Provider.of<CurrentBible>(context, listen: false);

    return _buildTitledContent(currentBible, verse);
  }

  _buildTitledContent(currentBible, List<dynamic> verse) {
    String thisTitleName = '${currentBible.curTitleList[verse[0]]} ';
    String thischapterIndexverseName = '${verse[1] + 1}:${verse[3]}';
    String title = thisTitleName + thischapterIndexverseName; //019973

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        _content(currentBible, verse),
      ],
    );
  }

  _content(currentBible, List<dynamic> verse) {
    return InkWell(
      onTap: () {
        _jumpToPage(currentBible, verse);
        //Navigator.pop(context);
      },
      //child: Text(verse[4])
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: CustomThemeData.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: buildWrappedString(verse[4]),
          ),
        ),
      ),
    );
  }

  buildWrappedString(String str) {
    Map<String, HighlightedWord> toHighlight = _toHighlight(context, str);

    return Wrap(
      children: str
          .toString()
          .trim()
          .split(' ')
          .map<Widget>(
            (text) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: TextHighlight(
                  text: text,
                  words: toHighlight,
                  textStyle: const TextStyle(fontSize: 12, height: 2),
                )),
          )
          .toList(),
    );
  }

  _toHighlight(context, str) {
    if (toSearch == null) {
      return <String, HighlightedWord>{};
    }
    return {
      for (String ts in toSearch)
        // for (String ts in toSearchSplitted)
        ts: HighlightedWord(
          textStyle: const TextStyle(
              fontSize: 12, height: 2, fontWeight: FontWeight.bold),
        ),
    };
  }

  _jumpToPage(currentBible, verse) {
    Navigator.pop(context);
    currentBible.setPageWithTS(verse[0], verse[1]);
    currentBible.addHistoryList(currentBible.lastBibleIndex, verse[2]);
    ListBuilder.scrollToVerse(verse);
  }
}
