import 'package:bible/main.dart';
import 'package:bible/provider/list.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/screens/verse_screen.dart';
import 'package:bible/widgets/list_builder.dart';
import 'package:bible/widgets/page_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String toSearch = '';
  List<Widget> searchList = [];
  AutoScrollController searchController = AutoScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '검색하기',
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  width: 320,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: SearchBar(
                      leading: const Icon(Icons.search),
                      onChanged: (value) {
                        setState(() {
                          toSearch = value;
                        });
                      },
                    ),
                  ),
                ),
                toSearch.length < 2 ? buildHistory() : buildSearchList(toSearch)
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildHistory() {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text(
            '검색 결과를 2자 이상 입력해 주세요',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }

  buildSearchList(toSearch) {
    _createSearchListView(toSearch);
    return searchList.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text('검색 결과가 없습니다.'),
          )
        : SizedBox(
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              controller: searchController,
              itemCount: searchList.length,
              itemBuilder: (context, searchIndex) {
                return searchList[searchIndex];
              },
            ),
          );
  }

  _createSearchListView(String toSearch) {
    searchList.clear();
    final rawBook =
        Provider.of<CurrentBible>(context, listen: false).curRawBook;
    for (List<dynamic> chapterIndex in rawBook) {
      for (var verse in chapterIndex) {
        String thisverse = verse[4].toString().trim();
        String thisTitleName = '${bookListKor[verse[0]]} ';
        String thisShortTitleName = '${bookListKorShort[verse[0]]} ';
        String thischapterIndexverseName = '${verse[1] + 1}:${verse[3]}';
        String defaultName = '${verse[1] + 1}장 ${verse[3]}절 ';
        String toCompare =
            thisTitleName + thisShortTitleName + defaultName + thisverse;
        String showingTitle = thisTitleName + thischapterIndexverseName;

        var toSearchSplitted = toSearch.split(' ');
        var allEquals =
            toSearchSplitted.every((element) => toCompare.contains(element));
        if (allEquals) {
          searchList.add(buildContentWithBookName(verse, showingTitle));
        }
      }
    }
  }

  buildContentWithBookName(List<dynamic> verse, String title) {
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
        _content(verse)
      ],
    );
  }

  _content(List<dynamic> verse) {
    return InkWell(
      onTap: () {
        CurrentBible currentBible =
            Provider.of<CurrentBible>(context, listen: false);

        currentBible.setPageWithTS(verse[0], verse[1]);
        Navigator.pop(context);

        ListBuilder.verseController.scrollToIndex(verse[2]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: CustomThemeData.colorScheme.background,
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
    return Wrap(
      children: str
          .toString()
          .trim()
          .split(' ')
          .map<Widget>(
            (text) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
          .toList(),
    );
  }
}
