import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/data/boxes.dart';
import 'package:time_tracker/states/task_state.dart';
import 'package:time_tracker/stopwatch/my_stopwatch.dart';

import '../data/task.dart';
import '../helper/duration_helper.dart';
import '../main.dart';

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
  State<StatefulWidget> createState() => _StopwatchCard();
}

class _StopwatchCard extends State<StopwatchCard> {
  late TextEditingController _controller;
  late Task _task;
  Timer? _timer = null;

  @override
  void initState() {
    print("StopwatchCard: initState with task = ${widget.task}");
    super.initState();
    _task = widget.task;
    _controller = TextEditingController(text: _task.name);
    _controller.addListener(() {
      _task.name = _controller.value.text;
    });

    if (_task.running) {
      _timer = Timer.periodic(
        const Duration(seconds: 1), (Timer timer) {
        _task.duration = Duration(seconds: _task.duration.inSeconds +1);
        _task.lastUpdate = DateTime.now();
        setState(() {});
      },
      );
    }
  }

  void _stop() {
    _timer?.cancel();
  }
  void _start() {
    _timer = Timer.periodic(
      const Duration(seconds: 1), (Timer timer) {
      _task.duration = Duration(seconds: _task.duration.inSeconds +1);
      _task.lastUpdate = DateTime.now();
      setState(() {});
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      // return ListenableBuilder(
      //     listenable: _task,
      //     builder: (context, child) {
            List<Widget> controlButtons = List.empty(growable: true);

            if (_timer?.isActive == true) {
              controlButtons.add(ElevatedButton(
                  onPressed: () {
                    _stop();
                    setState(() {});
                  },
                  child: const Icon(Icons.pause)));
            } else {
                controlButtons.add(ElevatedButton(
                    onPressed: () {
                      _start();
                      setState(() {});
                    },
                    child: const Icon(Icons.play_arrow)));

                controlButtons.add(ElevatedButton(
                    onPressed: () {
                      _stop();
                      // taskBox.delete(_stopwatch.task.id);
                      // taskHistoryBox.put(_stopwatch.task.id, _stopwatch.task);
                      // Provider.of<TaskState>(context, listen: false).removeTask(_task);
                    },
                    child: const Icon(Icons.stop)));
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
                            printDuration(_task.duration),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: controlButtons,
                          )
                        ]),
                  ),
             );

          // });
    } catch (a) {
      logger.e("StopwatchCard.build: could not bauild Card", error: a);
      rethrow;
    }
  }
}
