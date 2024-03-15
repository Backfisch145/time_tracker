
import 'package:flutter/material.dart';

import '../data/task.dart';
import '../stopwatch/my_stopwatch.dart';

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

  final List<MyStopwatch> stopwatches = List.empty(growable: true);
  final List<Task> taskHistory = List.empty(growable: true);

  void manualNotify() {
    notifyListeners();
  }


}