import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:time_tracker/stopwatch/MyStopwatch.dart';
import 'package:time_tracker/utils/DurationHelper.dart';

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
  final MyStopwatch? stopwatch;

  const StopwatchCard({
    super.key,
    this.stopwatch,
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
  TextEditingController? _controller = TextEditingController();
  late MyStopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = MyStopwatch.upwards();
  }

  @override
  Widget build(BuildContext context) {

    try {
      return ListenableBuilder(
          listenable: _stopwatch,
          builder: (context, child) {

            List<Widget> controlButtons = List.empty(growable: true);


            if (_stopwatch.isRunning()) {
              controlButtons.add(
                  ElevatedButton(
                      onPressed: () {
                        _stopwatch.stop();
                      },
                      child: Icon(Icons.pause)
                  )
              );
            } else {
              controlButtons.add(
                  ElevatedButton(
                      onPressed: () {
                        _stopwatch.start();
                      },
                      child: Icon(Icons.play_arrow)
                  )
              );
            }
            if (_stopwatch.duration.inMilliseconds > 0) {
              controlButtons.add(
                  ElevatedButton(
                      onPressed: () {
                        _stopwatch.stop();
                        // TODO: speichern der Stopwatch in der Datenbank
                      },
                      child: Icon(Icons.stop)
                  )
              );
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
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        printDuration(_stopwatch.duration),
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
                      // Spacer(),
                      Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: controlButtons,
                      )
                    ]
                ),
            );
          });
    } catch (a) {
      print("buildListEntry: ERROR - $a");
      rethrow;
    }
  }
}