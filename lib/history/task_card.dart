import 'package:flutter/material.dart';

import '../../data/task.dart';
import '../../helper/duration_helper.dart';

class TaskCard extends StatefulWidget {
  final bool enabled;
  final Color? color;
  final Color? onColor;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? surfaceTintColor;
  final double? elevation;
  final bool borderOnForeground;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;
  final bool semanticContainer;
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
    this.enabled = true,
    this.color,
    this.onColor,
    this.shadowColor,
    this.shape,
    this.surfaceTintColor,
    this.elevation,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.semanticContainer = true,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TextEditingController _controller;


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.name);
    _controller.addListener(() {
      widget.task.name = _controller.value.text;
    });
  }


  Widget _getTitle() {
    // if (widget.task.lastUpdate != null) {
    //   return Text(
    //     DateFormat('yyyy-MM-dd – kk:mm').format(widget.task.lastUpdate!),
    //     style: Theme.of(context).textTheme.titleSmall,
    //   );
    // } else {
      return Text(
        "UNKNOWN",
        style: Theme.of(context).textTheme.titleSmall,
      );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      shadowColor: widget.shadowColor,
      shape: widget.shape,
      surfaceTintColor: widget.surfaceTintColor,
      elevation: widget.elevation,
      borderOnForeground: widget.borderOnForeground,
      margin: widget.margin,
      clipBehavior: widget.clipBehavior,
      semanticContainer: widget.semanticContainer,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          // color: Colors.redAccent,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getTitle(),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Name eingeben',
                  border: InputBorder.none
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.onColor
                ),
              ),
              Text(
                printDuration(widget.task.duration),
                style: Theme.of(context).textTheme.titleMedium,
              ),

            ]
        ),
      ),
    );
  }
}