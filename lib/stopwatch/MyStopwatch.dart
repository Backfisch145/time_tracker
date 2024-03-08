import 'dart:async';

import 'package:flutter/material.dart';

class MyStopwatch with ChangeNotifier {

  String? title;
  Timer? _timer;
  Duration duration = const Duration();
  StopwatchDirection direction = StopwatchDirection.FORWARD;

  MyStopwatch.upwards({this.duration = const Duration()});

  MyStopwatch.downwards({this.duration = const Duration()}) {
    direction = StopwatchDirection.BACKWARD;
  }


  void start() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) {
            print("MyStopwatch.Timer: duration = ${duration.inSeconds}");
        switch (direction) {

          case StopwatchDirection.FORWARD: {
            duration = Duration(seconds: duration.inSeconds +1);
          }
          case StopwatchDirection.BACKWARD: {
            duration = Duration(seconds: duration.inSeconds -1);
          }
        }
        notify();
      },
    );
  }

  void stop() {
    if (_timer == null) {
      return;
    }

    if (_timer!.isActive) {
      _timer!.cancel();
    }
    notify();
  }

  void reset() {
    stop();
    duration = const Duration();
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
      this.duration = duration;
    }
  }

  void setDirection(StopwatchDirection direction) {
    this.direction = direction;
  }

  void dismantle() {
    // controller.close();
  }

}

enum StopwatchDirection { FORWARD, BACKWARD }
