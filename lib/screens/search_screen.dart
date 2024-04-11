import 'package:bible/provider/provider.dart';
import 'package:bible/widgets/search_history_builder.dart';
import 'package:bible/widgets/search_page_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late CurrentBible currentBible;

  String toSearch = '';

  @override
  void initState() {
    // TODO: implement initState
    currentBible = Provider.of<CurrentBible>(context, listen: false);
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
              '검색',
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

                toSearch.length < 2
                    ? const SearchHistoryBuilder()
                    : SearchPageBuilder(
                        toSearch: toSearch,
                      )
                // :SearchPageBuilder(toSearch:  toSearch)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

openSearchScreen(context) {
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
