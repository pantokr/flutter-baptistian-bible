import 'package:flutter_baptistian_bible/provider/provider.dart';
import 'package:flutter_baptistian_bible/widgets/search_content_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  @override
  void initState() {
    // TODO: implement initState
  }

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
              '저장된 말씀',
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
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: buildMemoBox(),
      ),
    );
  }

  buildMemoBox() {
    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        List toBuild = _verseToBuild(currentBible.memoList);
        //List curRawBook = currentBible.curRawBook;
        return ListView.separated(
          shrinkWrap: true,
          reverse: true,
          itemCount: toBuild.length,
          itemBuilder: (context, pageIndex) {
            var page = toBuild[pageIndex];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        currentBible.deleteMemoList(pageIndex);
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.delete),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildBundle(currentBible, page, pageIndex),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        );
      },
    );
  }

  _verseToBuild(List<String> memoList) {
    var res = [];
    for (String element in memoList) {
      List spl = element.split(':');
      var c = spl[0];
      var cv = spl.sublist(1).map((e) => [int.parse(c), int.parse(e)]).toList();
      res.add(cv);
    }
    return res;
  }

  _buildBundle(currentBible, List page, int pageIndex) {
    List res = page
        .map((verse) => SearchContentBuilder(
            context: context,
            verse: currentBible.curRawBook[verse[0]][verse[1]]))
        .toList();

    return res;
  }
}
