import 'package:bible/provider/provider.dart';
import 'package:bible/widgets/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageBuilder extends StatelessWidget {
  const PageBuilder({super.key});

  static PageController pageController = PageController();
  static jumpToPage(page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentBible>(
      builder: (context, currentBible, child) {
        pageController =
            PageController(initialPage: currentBible.lastBibleIndex);
        return PageView.builder(
          // preloadPagesCount: 5,
          physics: const CustomPageViewScrollPhysics(),
          controller: pageController,
          itemCount: currentBible.curOriginalBook.length,
          onPageChanged: (newPageIndex) {
            currentBible.setPage(newPageIndex);
          },
          itemBuilder: (context, chapterIndex) {
            return ListBuilder(
              chapterIndex: chapterIndex,
              copyMode: false,
            );
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
