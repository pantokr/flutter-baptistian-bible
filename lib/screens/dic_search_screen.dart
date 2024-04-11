import 'package:bible/screens/dic_search_web_view.dart';
import 'package:bible/theme/theme.dart';
import 'package:bible/widgets/dictionary.dart';
import 'package:flutter/material.dart';

class DicSearchScreen extends StatefulWidget {
  const DicSearchScreen({super.key});

  @override
  State<DicSearchScreen> createState() => _DicSearchScreenState();
}

class _DicSearchScreenState extends State<DicSearchScreen> {
  String toSearch = '';
  List urlList = [];
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
              '사전',
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              children: [buildSearchBar(), buildDicBox()],
            ),
          ),
        ),
      ),
    );
  }

  buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 240,
            child: SearchBar(
              leading: const Icon(Icons.search),
              onChanged: (value) {
                setState(() {
                  toSearch = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              width: 60,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black12),
              child: InkWell(
                onTap: () async {
                  var list = await getDictionary(toSearch);
                  setState(() {
                    urlList = list;
                  });
                },
                child: const Center(
                  child: Text(
                    '검색',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildDicBox() {
    if (urlList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(64.0),
        child: Text(
          '검색결과가 없습니다',
          style: TextStyle(fontSize: 24),
        ),
      );
    }

    return SizedBox(
      height: 600,
      child: ListView.builder(
        itemCount: urlList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DicSearchWebView(
                      url: urlList[index][1],
                      title: urlList[index][0],
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: CustomThemeData.color1,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            urlList[index][0],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              urlList[index][2],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
