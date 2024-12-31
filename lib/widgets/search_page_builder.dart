import 'package:flutter_baptistian_bible/provider/provider.dart';
import 'package:flutter_baptistian_bible/theme/theme.dart';
import 'package:flutter_baptistian_bible/widgets/search_content_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class SearchPageBuilder extends StatefulWidget {
  final String toSearch;
  const SearchPageBuilder({super.key, required this.toSearch});

  @override
  State<SearchPageBuilder> createState() => _SearchPageBuilder();
}

class _SearchPageBuilder extends State<SearchPageBuilder> {
  late CurrentBible currentBible;
  late String toSearch;
  late List<String> toSearchSplitted;

  int _currentPage = 0;
  List<int> scrollList = [];
  List<dynamic> searchList = [];
  List<dynamic> searchGroup = [];

  final PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    currentBible = Provider.of<CurrentBible>(context, listen: false);
  }

  @override
  void didUpdateWidget(covariant SearchPageBuilder oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    toSearch = widget.toSearch;
    toSearchSplitted = toSearch.trim().split(' ');
    return buildSearchList(toSearch);
  }

  buildSearchList(toSearch) {
    searchList = _createSearchList(toSearch);
    searchGroup = _compressList(searchList);
    scrollList = _scrollList();

    return searchGroup.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Text('검색 결과가 없습니다.'),
          )
        : Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: scrollList.length,
                    itemBuilder: (context, pageIndex) {
                      return buildScrollBar(pageIndex);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  // currentBible.curTitleList[scrollList[_currentPage]],
                  currentBible.curTitleList[scrollList[_currentPage]],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 540,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: searchGroup.length,
                  itemBuilder: (context, searchIndex) {
                    return buildGroup(searchGroup[searchIndex]);
                  },
                ),
              ),
            ],
          );
  }

  _createSearchList(String toSearch) {
    searchList.clear();

    for (List<dynamic> chapterIndex in currentBible.curRawBook) {
      for (var verse in chapterIndex) {
        String thisverse = verse[4].toString().trim();
        String thisTitleName = '${currentBible.curTitleList[verse[0]]} ';
        String thisShortTitleName =
            '${currentBible.curTitleListShort[verse[0]]} ';
        //String thischapterIndexverseName = '${verse[1] + 1}:${verse[3]}';
        String defaultName = '${verse[1] + 1}장 ${verse[3]}절 ';
        String toCompare =
            thisTitleName + thisShortTitleName + defaultName + thisverse;
        //String showingTitle = thisTitleName + thischapterIndexverseName;

        var allEquals =
            toSearchSplitted.every((element) => toCompare.contains(element));
        if (allEquals) {
          searchList.add(verse);
        }
      }
    }
    return searchList;
  }

  _compressList(List searchList) {
    List resList = [];
    for (int i = 0; i < currentBible.curTitleList.length; i++) {
      List tList = searchList.where((element) => element[0] == i).toList();
      if (tList.isNotEmpty) {
        resList.add(tList);
      }
    }

    return resList;
  }

  buildScrollBar(pageIndex) {
    return InkWell(
      onTap: () {
        pageController.jumpToPage(pageIndex);
        Future.delayed(Durations.short1, () {
          setState(
            () {
              _currentPage = pageController.page!.toInt();
            },
          );
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          width: 40,
          decoration: BoxDecoration(
              color: CustomThemeData.publicColor1,
              borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: Text(
              currentBible.curTitleListShort[scrollList[pageIndex]],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  _scrollList() {
    List<int> tList = [];
    for (var sg in searchGroup) {
      tList.add(sg[0][0]);
    }
    return tList;
  }

  buildGroup(List<dynamic> group) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: group.length,
      itemBuilder: (context, verseIndex) {
        return SearchContentBuilder(
          context: context,
          verse: group[verseIndex],
          toSearch: toSearchSplitted,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
