import 'package:flutter_baptistian_bible/init/preference_manager.dart';
import 'package:flutter_baptistian_bible/provider/provider.dart';
import 'package:flutter_baptistian_bible/widgets/search_content_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchHistoryBuilder extends StatefulWidget {
  const SearchHistoryBuilder({super.key});

  @override
  State<SearchHistoryBuilder> createState() => _SearchHistoryBuilderState();
}

class _SearchHistoryBuilderState extends State<SearchHistoryBuilder> {
  @override
  Widget build(BuildContext context) {
    CurrentBible currentBible =
        Provider.of<CurrentBible>(context, listen: false);

    return buildHistory(context, currentBible);
  }

  buildHistory(context, currentBible) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '검색 내용을 2자 이상 입력해 주세요',
            style: TextStyle(fontSize: 20),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _history(context, currentBible),
          ),
        )
      ],
    );
  }

  _history(context, currentBible) {
    List<String> hList = pref.getStringList('historyList')!;
    List<Widget> widgetList = [];

    for (String element in hList.reversed) {
      var tList = element.split(':').map((e) => int.parse(e)).toList();

      widgetList.add(SearchContentBuilder(
          context: context,
          verse: currentBible.curRawBook[tList[0]][tList[1]]));
      if (widgetList.length >= 5) {
        break;
      }
    }
    widgetList = widgetList
        .map(
          (e) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 4,
              ),
              e
            ],
          ),
        )
        .toList();
    return widgetList;
  }
}
