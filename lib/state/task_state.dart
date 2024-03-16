
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:time_tracker/data/task.dart';

import '../main.dart';

class TaskState extends ChangeNotifier {
  final List<Task> _tasks = [];

  UnmodifiableListView<Task> get allTasks => UnmodifiableListView(_tasks);

  UnmodifiableListView<Task> get runningTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completion == null && task.running));
  UnmodifiableListView<Task> get stoppedTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completion == null && !task.running));
  UnmodifiableListView<Task> get uncompletedTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completion == null));
  UnmodifiableListView<Task> get completedTasks =>
      UnmodifiableListView(_tasks.where((task) => task.completion != null));

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    final taskIndex = _tasks.indexOf(task);
    _tasks[taskIndex].completion = DateTime.now();
    notifyListeners();
  }

  void finishTask(Task task) {
    task.completion = DateTime.now();
    notifyListeners();
  }

  void updateTask(Task task) {
    _tasks.remove(task);
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