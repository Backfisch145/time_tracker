import 'dart:async' show Timer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../data/boxes.dart';
import '../data/task.dart';

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

  // void finish() {
  //   if (kDebugMode) {
  //     print("MyStopwatch.finish: called()");
  //     print("MyStopwatch.finish: task = $task");
  //   }
  //
  //   task.lastUpdate = DateTime.now();
  //   _timer?.cancel();
  //   task.running = false;
  //   taskBox.delete(task.id);
  //   taskHistoryBox.put(task.id, task);
  //    notify();
  // }

  void stop() {
    if (kDebugMode) {
      print("MyStopwatch.stop: called()");
    }
    task.running = false;
    _timer?.cancel();
    task.lastUpdate = DateTime.now();
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

  @override
  String toString() {
    return 'MyStopwatch{task: $task, direction: $direction}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyStopwatch &&
          runtimeType == other.runtimeType &&
          task.id == other.task.id &&
          direction == other.direction;

  @override
  int get hashCode => task.hashCode ^ direction.hashCode;
}

enum StopwatchDirection { forward, backward }
