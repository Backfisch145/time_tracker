import 'package:flutter/material.dart';

import '../../data/task.dart';
import '../../helper/duration_helper.dart';

class TaskCard extends StatelessWidget {
  final bool enabled;
  final Color? color;
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
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shadowColor: shadowColor,
      shape: shape,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      borderOnForeground: borderOnForeground,
      margin: margin,
      clipBehavior: clipBehavior,
      semanticContainer: semanticContainer,
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
              Text(
                printDuration(task.duration),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                  task.name
              )
            ]
        ),
      ),
    );
  }
}