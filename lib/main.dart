import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/data/adapter/duration_adapter.dart';
import 'package:time_tracker/data/boxes.dart';
import 'package:time_tracker/state/task_state.dart';
import 'package:time_tracker/stopwatch/stopwatch_page.dart';
import 'package:time_tracker/data/task.dart';
import 'package:time_tracker/data/adapter/task_adapter.dart';
import 'package:time_tracker/theme/color_schemes.dart';


var logger = Logger(
  printer: PrettyPrinter(),
);



void main() async {


  await Hive.initFlutter();
  Hive
    ..registerAdapter(TaskAdapter())
    ..registerAdapter(DurationAdapter());
  taskBox = await Hive.openBox<Task>("taskBox");



  runApp(ChangeNotifierProvider(
    create: (context) {
      TaskState ts = TaskState();

      Timer.periodic(
        const Duration(seconds: 1), (Timer timer) {
          ts.incDuration();
        },
      );
      _addSavedTasksToGlobalState(context, ts);
      return ts;
    },
    child: const MyApp(),
  ));
}

void _addSavedTasksToGlobalState(BuildContext context, TaskState gs) {
  if (kDebugMode) {
    print("Main._addSavedTasksToGlobalState: called()");
  }
  for (var element in taskBox.values) {
    if (kDebugMode) {
      print("Main._addSavedTasksToGlobalState: add task: $element");
    }
    gs.addTask(element);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker\n Fabian Jäger 349405',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return const StopwatchPage();
  }

  @override
  void initState() {
    if (kDebugMode) {
      print("Main.initState: called()");
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("Main.dispose: called()");
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  _saveTasksToHive(TaskState gState) async {
    if (kDebugMode) {
      print("Main._saveTasksToHive: called()");
    }

    for (var value in gState.allTasks) {
      Task t = value;
      await taskBox.put(t.id, t);
      if (kDebugMode) {
        print("Main._saveTasksToHive: saved Task $t");
      }
    }
    taskBox.flush();
  }
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print("Main.didChangeAppLifecycleState: called with state = $state");
    }
    super.didChangeAppLifecycleState(state);
    TaskState gState = Provider.of<TaskState>(context, listen: false);
    if (state == AppLifecycleState.paused) {

      _saveTasksToHive(gState);
    }
  }
}
