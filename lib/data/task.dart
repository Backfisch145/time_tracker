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

  Task();

  @override
  String toString() {
    return 'Task{id: $id, name: $name, lastStop: $lastUpdate, duration: $duration, running: $running}';
  }
}
