import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/data/boxes.dart';
import 'package:time_tracker/stopwatch/my_stopwatch.dart';

import '../helper/duration_helper.dart';
import '../main.dart';
import '../states/global_state.dart';

class StopwatchCard extends StatefulWidget {
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
  final MyStopwatch stopwatch;

  const StopwatchCard({
    super.key,
    required this.stopwatch,
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
  State<StatefulWidget> createState() => _StopwatchCard();
}

class _StopwatchCard extends State<StopwatchCard> {
  late TextEditingController _controller;
  late MyStopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = widget.stopwatch;
    _controller = TextEditingController(text: _stopwatch.task.name);
    _controller.addListener(() {
      _stopwatch.task.name = _controller.value.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return ListenableBuilder(
          listenable: _stopwatch,
          builder: (context, child) {
            List<Widget> controlButtons = List.empty(growable: true);

            if (_stopwatch.isRunning()) {
              controlButtons.add(ElevatedButton(
                  onPressed: () {
                    _stopwatch.stop();
                  },
                  child: const Icon(Icons.pause)));
            } else {
              controlButtons.add(ElevatedButton(
                  onPressed: () {
                    _stopwatch.start();
                  },
                  child: const Icon(Icons.play_arrow)));
            }
            if (_stopwatch.task.duration.inMilliseconds > 0) {
              controlButtons.add(ElevatedButton(
                  onPressed: () {
                    _stopwatch.stop();
                    taskBox.delete(_stopwatch.task.id);
                    taskHistoryBox.put(_stopwatch.task.id, _stopwatch.task);

                    GlobalState state =
                        Provider.of<GlobalState>(context, listen: false);
                    state.taskHistory.add(_stopwatch.task);
                    state.stopwatches.remove(_stopwatch);
                    state.manualNotify();
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
                        printDuration(_stopwatch.task.duration),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(
                        width: 320,
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Name eingeben',
                            // border: InputBorder.none
                          ),
                          textAlign: TextAlign.center,
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
          });
    } catch (a) {
      logger.e("StopwatchCard.build: could not bauild Card", error: a);
      rethrow;
    }
  }
}
