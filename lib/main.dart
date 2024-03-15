import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/data/adapter/duration_adapter.dart';
import 'package:time_tracker/data/boxes.dart';
import 'package:time_tracker/data/task.dart';
import 'package:time_tracker/history/history_page.dart';
import 'package:time_tracker/stopwatch/my_stopwatch.dart';
import 'package:time_tracker/stopwatch/stopwatch_page.dart';

import 'data/adapter/task_adapter.dart';
import 'states/global_state.dart';


var logger = Logger(
  printer: PrettyPrinter(),
);

void main() async {


  await Hive.initFlutter();
  //await Hive.deleteBoxFromDisk("taskBox");
  Hive
    ..registerAdapter(TaskAdapter())
    ..registerAdapter(DurationAdapter());
  taskBox = await Hive.openBox<Task>("taskBox");
  taskHistoryBox = await Hive.openBox<Task>("taskHistoryBox");

  runApp(ChangeNotifierProvider(
    create: (context) {
      GlobalState gs = GlobalState();
      _addSavedTasksToGlobalState(gs);
      return gs;
    },
    child: const MyApp(),
  ));
}

void _addSavedTasksToGlobalState(GlobalState gs) async {
  if (!taskBox.isOpen) {
    taskBox = await Hive.openBox<Task>("taskBox");
  }

  if (kDebugMode) {
    print("Main._addSavedTasksToGlobalState: called()");
  }
  for (var element in taskBox.values) {
    if (kDebugMode) {
      print("Main._addSavedTasksToGlobalState: add task: $element");
    }
    MyStopwatch sw = MyStopwatch.upwards(task: element);
    if (element.running) {
      sw.start();
    }
    gs.stopwatches.add(sw);
  }
  gs.manualNotify();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker\n Fabian Jäger 349405',
      theme: ThemeData(
        useMaterial3: true,
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(100, 173, 166, 147), brightness: Brightness.light),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(100, 168, 159, 130), brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(100, 173, 166, 147), brightness: Brightness.dark),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Page {
  // FAVOURITES(icon: Icons.star),
  stopwatches(icon: Icons.event_note),
  history(icon: Icons.history);

  final IconData icon;

  const Page({required this.icon});
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  Page selectedPage = Page.stopwatches;

  void _setSelectedPage(Page selectedPage) {
    setState(() {
      this.selectedPage = selectedPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    return Consumer<GlobalState>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(value.title),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/main_background.jpg"), fit: BoxFit.cover),
          ),
          child: switch (selectedPage) {
            Page.stopwatches => const StopwatchPage(),
            Page.history => const HistoryPage(),
          },
        ),
        floatingActionButton: value.fab,
        bottomNavigationBar: Visibility(
          visible: value.showBottomNavBar,
          child: BottomNavigationBar(
            items: Page.values
                .map((e) =>
                BottomNavigationBarItem(label: e.name, icon: Icon(e.icon)))
                .toList(),
          onTap: (pos) => {_setSelectedPage(Page.values[pos])},
          currentIndex: Page.values.indexOf(selectedPage),
        )),
      ),
    );
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


  _saveTasksToHive(GlobalState gState) async {
    if (kDebugMode) {
      print("Main._saveTasksToHive: called()");
    }
    // await boxTask.clear();

    for (var value in gState.stopwatches) {
      Task t = value.task;
      await taskBox.put(t.id, t);
      if (kDebugMode) {
        print("Main._saveTasksToHive: saved Task $t");
      }
    }
    taskBox.flush();

    for (var task in gState.taskHistory) {
      await taskHistoryBox.put(task.id, task);
      if (kDebugMode) {
        print("Main._saveTasksToHive: saved HistoryTask $task");
      }
    }
    taskHistoryBox.flush();
  }
  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print("Main.didChangeAppLifecycleState: called with state = $state");
    }
    super.didChangeAppLifecycleState(state);
    GlobalState gState = Provider.of<GlobalState>(context, listen: false);
    if (state == AppLifecycleState.paused) {

      _saveTasksToHive(gState);
    }

    if (state == AppLifecycleState.resumed) {
      // _addSavedTasksToGlobalState(gState);
    }
  }
}
