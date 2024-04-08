import 'package:bible/main.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/widgets/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  Color boxColor = CustomThemeData.colorScheme.background;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    pageController = PageController(
        initialPage: Provider.of<CurrentBible>(context, listen: false)
            .lastBibleIndex); //Page 컨트롤을 위한 PageController 선언 시작 페이지 0

    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        return PageView.builder(
          physics: const CustomPageViewScrollPhysics(),
          controller: pageController,
          itemCount: currentBible.curOriginalBook.length,
          onPageChanged: (newPageIndex) {
            currentBible.setPage(newPageIndex);
          },
          itemBuilder: (context, chapterIndex) {
            return const ListBuilder();
          },
        );
      },
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
        mass: 70,
        stiffness: 1,
        damping: 0.5,
      );
}
