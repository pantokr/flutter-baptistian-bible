import 'package:bible/provider/provider.dart';
import 'package:bible/screens/copy_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerseBuilder extends StatefulWidget {
  static PageController pageController = PageController(initialPage: 0);

  const VerseBuilder({super.key});

  @override
  State<VerseBuilder> createState() => _VerseBuilderState();
}

class _VerseBuilderState extends State<VerseBuilder> {
  Color boxColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    VerseBuilder.pageController = PageController(
        initialPage: Provider.of<CurrentBible>(context, listen: false)
            .lbindex); //Page 컨트롤을 위한 PageController 선언 시작 페이지 0

    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        return PageView.builder(
          //physics: const PageScrollPhysics(),

          physics: const CustomPageViewScrollPhysics(),
          controller: VerseBuilder.pageController,
          itemCount: currentBible.curBook.length,

          onPageChanged: (newPageIndex) {
            currentBible.setPage(newPageIndex);
          },
          itemBuilder: (context, cht) {
            return ListView.builder(
              itemCount: currentBible.curBook[cht].length,
              itemBuilder: (context, sec) {
                if (currentBible.curBook[cht][sec].length > 5 &&
                    currentBible.curBook[cht][sec][5] != '') {
                  return _buildContentWithSmallTitle(
                      currentBible.curBook[cht][sec]);
                }
                return _buildContent(currentBible.curBook[cht][sec]);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildContent(List<dynamic> secList) {
    return InkWell(
      onLongPress: () {
        CopyScreen.openCopyScreen(context);
      },
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 32,
                  child: Text(
                    secList[0].toString(),
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 16),
                  )),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: secList[1].toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentWithSmallTitle(
    List<dynamic> sec,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            sec[5],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildContent(sec)
      ],
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({super.parent});

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 40,
        stiffness: 100,
        damping: 8,
      );
}
