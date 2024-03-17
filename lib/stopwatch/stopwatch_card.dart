
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/state/task_state.dart';

import '../helper/duration_helper.dart';
import '../main.dart';
import '../data/task.dart';

class StopwatchCard extends StatefulWidget {
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

  const StopwatchCard({
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
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {

  late TextEditingController _controller;


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.name);
    _controller.addListener(() {
      Provider.of<TaskState>(context, listen: false).setTaskName(widget.task, _controller.value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      List<Widget> controlButtons = List.empty(growable: true);

      if (widget.task.running) {
        controlButtons.add(ElevatedButton(
            onPressed: () {
              Provider.of<TaskState>(context, listen: false).toggleTask(widget.task);
            },
            child: const Icon(Icons.pause)));
        controlButtons.add(const Gap(24));
        controlButtons.add(ElevatedButton(
            onPressed: () {
              Provider.of<TaskState>(context, listen: false).finishTask(widget.task);
            },
            child: const Icon(Icons.stop)));
      } else {
        controlButtons.add(ElevatedButton(
            onPressed: () {
              Provider.of<TaskState>(context, listen: false).toggleTask(widget.task);
            },
            child: const Icon(Icons.play_arrow)));
      }

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
        child: Stack(
            children: [

              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        printDuration(widget.task.duration),
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: widget.onColor
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Name eingeben',
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: widget.onColor
                          ),
                        ),
                      ),
                      const Gap(4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: controlButtons,
                      )
                    ]),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.delete), // Replace 'your_icon' with your desired icon
                  onPressed: () {
                    TaskState gState = Provider.of<TaskState>(context, listen: false);
                    gState.deleteTask(widget.task);
                  },
                ),
              ),
            ]
        )
      );
    } catch (a) {
      logger.e("StopwatchCard.build: could not bauild Card", error: a);
      rethrow;
    }
  }
}
