import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  String? id = UniqueKey().toString();
  @HiveField(1)
  String name = "";
  @HiveField(3)
  DateTime? lastUpdate;
  @HiveField(4)
  Duration duration = Duration.zero;
  @HiveField(5)
  bool running = false;
  @HiveField(6)
  DateTime? completion;
  @HiveField(7)
  DateTime creation = DateTime.now();

  Task();

  void incDuration() {
    duration = Duration(seconds: duration.inSeconds + 1);
    lastUpdate = DateTime.now();
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name, lastStop: $lastUpdate, duration: $duration, running: $running}';
  }

  void toggleRunning() {
    running = !running;
    lastUpdate = DateTime.now();
  }
}
