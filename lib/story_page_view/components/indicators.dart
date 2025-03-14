import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story/story_page_view/story_limit_controller.dart';

import '../story_stack_controller.dart';

class Indicators extends StatefulWidget {
  const Indicators(
      {Key? key,
      required this.animationController,
      required this.storyLength,
      required this.isCurrentPage,
      required this.isPaging,
      required this.padding,
      required this.color,
      required this.spacing,
      required this.height})
      : super(key: key);
  final int storyLength;
  final AnimationController? animationController;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double height;
  final double spacing;
  final bool isCurrentPage;
  final bool isPaging;

  @override
  _IndicatorsState createState() => _IndicatorsState();
}

class _IndicatorsState extends State<Indicators> {
  late Animation<double> indicatorAnimation;

  @override
  void initState() {
    super.initState();
    widget.animationController!.forward();
    indicatorAnimation =
        Tween(begin: 0.0, end: 1.0).animate(widget.animationController!)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final int currentStoryIndex = context.watch<StoryStackController>().value;
    final bool isStoryEnded = context.watch<StoryLimitController>().value;
    if (!widget.isCurrentPage && widget.isPaging) {
      widget.animationController!.stop();
    }
    if (!widget.isCurrentPage &&
        !widget.isPaging &&
        widget.animationController!.value != 0) {
      widget.animationController!.value = 0;
    }
    if (widget.isCurrentPage &&
        !widget.animationController!.isAnimating &&
        !isStoryEnded) {
      widget.animationController!.forward(from: 0);
    }
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.storyLength,
          (index) => _Indicator(
            index: index,
            indicatorColor: widget.color,
            sidePadding: widget.spacing,
            indicatorHeight: widget.height,
            value: (index == currentStoryIndex)
                ? indicatorAnimation.value
                : (index > currentStoryIndex)
                    ? 0
                    : 1,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.animationController!.dispose();
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator(
      {Key? key,
      required this.index,
      required this.value,
      required this.indicatorColor,
      this.indicatorHeight: 2,
      this.sidePadding: 4})
      : super(key: key);
  final int index;
  final double value;
  final Color indicatorColor;
  final double sidePadding;
  final double indicatorHeight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: (index == 0) ? 0 : sidePadding),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(indicatorHeight / 2)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: LinearProgressIndicator(
              value: value,
              backgroundColor: indicatorColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              minHeight: indicatorHeight),
        ),
      ),
    );
  }
}
