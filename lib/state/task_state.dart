
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:time_tracker/data/boxes.dart';
import 'package:time_tracker/data/task.dart';

import '../main.dart';

class TaskState extends ChangeNotifier {
  final List<Task> _tasks = [];

  UnmodifiableListView<Task> get allTasks => UnmodifiableListView(_tasks);

  UnmodifiableListView<Task> get runningTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completion == null && task.running));
  UnmodifiableListView<Task> get stoppedTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completion == null && !task.running));
  UnmodifiableListView<Task> get uncompletedTasks {
    List<Task> filteredTasks = _tasks
        .where((task) => task.completion == null)
        .toList();
    filteredTasks.sort((a, b) => a.creation.isAfter(b.creation)?1:0);

    return UnmodifiableListView(filteredTasks);
  }
  UnmodifiableListView<Task> get completedTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completion != null));

  void addTask(Task task) {
    _tasks.add(task);
    taskBox.put(task.id, task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    taskBox.delete(task.id);
    notifyListeners();
  }

  void finishTask(Task task) {
    task.completion = DateTime.now();
    taskBox.put(task.id, task);
    notifyListeners();
  }

  void incDuration() {
    if (kDebugMode) {
      print("TaskState.incDuration called()");
    }
    for (var element in runningTasks) {
      element.incDuration();
    }
    notifyListeners();
  }

  void stopTask(Task task) {
    try {
      runningTasks.firstWhere((element) => element == task).toggleRunning();
      notifyListeners();
    } on Exception catch (_, e) {
      logger.d(e);
    }
  }
  void startTask(Task task) {
    try {
      stoppedTasks.firstWhere((element) => element == task).toggleRunning();
      notifyListeners();
    } on Exception catch (_, e) {
      logger.d(e);
    }

  }
  void toggleTask(Task task) {
    try {
      allTasks.firstWhere((element) => element == task).toggleRunning();
      notifyListeners();
    } on Exception catch (_, e) {
      logger.d(e);
    }
  }

  void setTaskName(Task task, String text) {
    task.name = text;
    notifyListeners();
  }


}