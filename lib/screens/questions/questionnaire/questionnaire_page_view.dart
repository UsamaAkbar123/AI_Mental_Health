import 'package:flutter/material.dart';

class QuestionnairePageView extends StatefulWidget {
  final List<Widget> widgets;

  const QuestionnairePageView({super.key, required this.widgets});


  @override
  State<QuestionnairePageView> createState() => QuestionnairePageViewState();
}

class QuestionnairePageViewState extends State<QuestionnairePageView>
    with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController(keepPage: true);
  int currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.widgets.map((widget) {
        return PageStorage(
          bucket: PageStorageBucket(),
          key: widget.key,
          child: widget,
        );
      }).toList(),
    );
  }

  /// Function to go to the next page
  void goToNextPage() {
    if (currentPage < widget.widgets.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Function to go to the previous page
  void goToPreviousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }
}
