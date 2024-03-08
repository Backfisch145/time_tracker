import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class ExpandableCard extends StatefulWidget {
  final List<Widget>? expandableChildren;
  final Widget title;
  final bool enabled;
  final Color? color;
  final Color? colorExpanded;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? surfaceTintColor;
  final double? elevation;
  final bool borderOnForeground;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;
  final bool semanticContainer;
  final Widget? trailing;

  const ExpandableCard({
    super.key,
    required this.title,
    this.enabled = true,
    this.color,
    this.colorExpanded,
    this.shadowColor,
    this.shape,
    this.surfaceTintColor,
    this.elevation,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.semanticContainer = true,
    this.expandableChildren,
    this.trailing,
  });



  @override
  State<StatefulWidget> createState() => _ExpandableCard();

}

class _ExpandableCard extends State<ExpandableCard> {
  bool expanded = false;


  @override
  void initState() {
    super.initState();
  }

  void toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {


    List<Widget> content = List.empty(growable: true);

    content.add(buildTitleBar());

    if (expanded && widget.expandableChildren != null && widget.expandableChildren!.isNotEmpty) {
      content.add(const Divider());
      content.addAll(widget.expandableChildren!);
    }

    try {
      return GestureDetector(
        onTap: () => toggleExpansion(),
        child: Card(
          color: expanded ? widget.colorExpanded : widget.color,
          shadowColor: widget.shadowColor,
          shape: widget.shape,
          surfaceTintColor: widget.surfaceTintColor,
          elevation: widget.elevation,
          borderOnForeground: widget.borderOnForeground,
          margin: widget.margin,
          clipBehavior: widget.clipBehavior,
          semanticContainer: widget.semanticContainer,
          child: Column(
              children: content
          ),
        ),
      );

    } catch (a) {
      print("buildListEntry: ERROR - $a");
      rethrow;
    }
  }


  Widget buildTitleBar() {
    List<Widget> titleBar = List.empty(growable: true);
    List<Widget> titleFront = List.empty(growable: true);
    if (widget.expandableChildren != null && widget.expandableChildren!.isNotEmpty) {
      titleFront.add(expanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more));
      titleFront.add(const Gap(8));
    } else {
      titleFront.add(const Gap(32));
    }
    titleFront.add(widget.title);


    titleBar.add(
        Row(children: titleFront)
    );
    if (widget.trailing != null) {
      titleBar.add(widget.trailing!);
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: titleBar,
    );
  }

// IconButton getExpandButton() {
//   Icon i = expanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more);
//   return IconButton(onPressed: () => {setExpanded(!expanded), f.call()}, icon: i);
// }
}