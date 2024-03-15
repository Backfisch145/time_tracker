import 'dart:async' show Timer;

import 'package:flutter/foundation.dart';
import 'package:time_tracker/data/task.dart';

class MyStopwatch with ChangeNotifier {

  Task task;

  Timer? _timer;
  StopwatchDirection direction = StopwatchDirection.forward;

  MyStopwatch.upwards({required this.task});

  // MyStopwatch.downwards({required this.task}) {
  //   direction = StopwatchDirection.BACKWARD;
  // }

  void start() {
    if (kDebugMode) {
      print("MyStopwatch.start: called() ");
    }
    _timer?.cancel();
    task.running = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1), (Timer timer) {
        switch (direction) {

          case StopwatchDirection.forward: {
            task.duration = Duration(seconds: task.duration.inSeconds +1);
          }
          case StopwatchDirection.backward: {
            task.duration = Duration(seconds: task.duration.inSeconds -1);
          }
        }
        task.lastUpdate = DateTime.now();
        notify();
      },
    );
  }

  void stop() {
    if (kDebugMode) {
      print("MyStopwatch.stop: called()");
    }
    task.running = false;
    if (_timer == null) {
      return;
    }

    if (_timer!.isActive) {
      _timer!.cancel();
    }
    notify();
  }

  bool isRunning() {
    if (_timer == null) {
      return false;
    }
    return _timer!.isActive;
  }

  void notify() {
    notifyListeners();
    // controller.add(duration);
  }

  void setDuration(Duration duration) {
    if (_timer != null) {
      throw Exception(
          "Duration can only be set, if the Stopwatch is not running");
    } else {
      task.duration = duration;
    }
  }

  void setDirection(StopwatchDirection direction) {
    this.direction = direction;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

}

enum StopwatchDirection { forward, backward }
