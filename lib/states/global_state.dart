import 'package:flutter/material.dart';
import 'package:time_tracker/projects/data/task_entity.dart';

class GlobalState extends ChangeNotifier{

  String _title = "TITLE ININITIALIZED";
  String get title => _title;
  set title (title) {
    _title = title;
    notifyListeners();
  }

  FloatingActionButton? _fab;
  FloatingActionButton? get fab => _fab;
  set fab (fab){
    _fab = fab;
    notifyListeners();
  }

  bool _showBottomNavBar = true;
  bool get showBottomNavBar => _showBottomNavBar;
  set showBottomNavBar (fab){
    _showBottomNavBar = fab;
    notifyListeners();
  }

  List<TaskEntity> _tasks = [
    TaskEntity(name: "In dem Login Activity wird die Unterschrift nicht angezeigt"),
    TaskEntity(name: "Aufträge werden nicht richtig in den Handover übertragen"),
    TaskEntity(name: "Konzepte der Andorid Programmierung fertig machen", deadline: DateTime(2024, 3, 18))
  ];
  List<TaskEntity> get tasks => _tasks;
  set tasks (tasks){
    _tasks = tasks;
    notifyListeners();
  }
  void manualNotify() {
    notifyListeners();
  }


}