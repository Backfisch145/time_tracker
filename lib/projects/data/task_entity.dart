import 'package:flutter/cupertino.dart';
import 'package:time_tracker/projects/data/task_execution_entity.dart';

class TaskEntity {
  String? id;
  String name = "";
  int version = 0;
  DateTime creation = DateTime.now();
  DateTime? deadline;
  List<TaskEntity> subTasks = List.empty(growable: true);
  List<TaskExecutionEntity> taskExecutions = List.empty(growable: true);

  TaskEntity({required this.name, this.deadline}) {
    if (name.trim().isEmpty) {
      throw ArgumentError("name must not be NULL");
    }
    id = UniqueKey().toString();
  }

  Map<String, dynamic> toFirebaseDoc() {
    return <String, dynamic> {
      "id": id,
      "name": name,
      "version": version++,
      "creation": creation,
      "deadline": deadline,
      "subTasks": subTasks
    };
  }

  // int getDuration() {
  //   if (taskExecutions.isEmpty) {
  //     return 0;
  //   }
  //   return taskExecutions.fold(0, (previousValue, element) => previousValue + element.duration.inSeconds ?? 0);
  // }
}
