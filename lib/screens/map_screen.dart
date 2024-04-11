import 'package:bible/provider/list.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/screens/map_image_view.dart';
import 'package:bible/theme/theme.dart';
import 'package:bible/widgets/search_content_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
                '지도',
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
        body: buildMapTab() //buildMapTab(),
        );
  }

  buildMapTab() {
    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        //List curRawBook = currentBible.curRawBook;
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  SizedBox(
                    height: 64,
                    child: Center(
                      child: Text(
                        'Old',
                        style: TextStyle(
                            fontSize: 32,
                            color: CustomThemeData.colorScheme.primary),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 64,
                    child: Center(
                      child: Text(
                        'New',
                        style: TextStyle(
                            fontSize: 32,
                            color: CustomThemeData.colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBarView(children: [_oldMaps(), _newMaps()]),
              ))
            ],
          ),
        );
      },
    );
  }

  _oldMaps() {
    var oldList = [oldMapList, oldAdditionalMapList];
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (context, mapListIndex) {
        return _makeListView(oldList[mapListIndex]);
      },
      separatorBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(
            thickness: 8,
          ),
        );
      },
    );
  }

  _newMaps() {
    return SingleChildScrollView(child: _makeListView(newMapList));
    //return const Placeholder();
  }

  _makeListView(List<String> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, mapIndex) {
        return buildBox(list[mapIndex], mapIndex);
      },
    );
  }

  buildBox(String title, mapIndex) {
    int ind = title.indexOf(' ');
    List<String> titleSplitted = [
      title.substring(0, ind),
      title.substring(ind)
    ];

    String imageUrl = _image(title);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MapImageView(
                imageUrl: imageUrl,
                title: titleSplitted[0],
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      titleSplitted[0],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
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
                        titleSplitted[1],
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
  }

  _image(String title) {
    if (oldMapList.contains(title)) {
      // type old
      return 'assets/images/old/${oldMapList.indexOf(title)}.jpg';
    }
    if (oldAdditionalMapList.contains(title)) {
      // type old_additional
      return 'assets/images/old_additional/${oldAdditionalMapList.indexOf(title)}.jpg';
    }
    if (newMapList.contains(title)) {
      // type new
      return 'assets/images/new/${newMapList.indexOf(title)}.jpg';
    }
  }
}
