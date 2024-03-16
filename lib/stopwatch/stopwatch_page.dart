import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/history/history_page.dart';
import 'package:time_tracker/state/task_state.dart';
import 'package:time_tracker/stopwatch/stopwatch_card.dart';

import '../about/about_page.dart';
import '../data/task.dart';



class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key,});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {

  void _newStopwatch() {
    if (kDebugMode) {
      print("StopwatchPage.newStopwatch: called()");
    }
    var task = Task();
    if (kDebugMode) {
      print("StopwatchPage.newStopwatch: newTask = $task");
    }
    TaskState state = Provider.of<TaskState>(context, listen: false);
    state.addTask(task);
  }
  Route _routeToHistory() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HistoryPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  Route _routeToAbout() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const AboutPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    if (kDebugMode) {
      print("StopwatchPage.build: called()");
    }

    Color appBarColor = Theme.of(context).colorScheme.primary;
    Color onAppBarColor = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
            "Stopuhren",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary
            )
        ),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                  _routeToHistory()
              )
            },
            icon: const Icon(Icons.history),
            color: onAppBarColor,
          ),
          IconButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  _routeToAbout()
              )
            },
            icon: const Icon(Icons.info),
            color: onAppBarColor,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/background.jpg"), fit: BoxFit.cover),
        ),
        child: Consumer<TaskState>(
          builder: (context, state, child) {
            return ListView.separated(
              itemCount: state.uncompletedTasks.length,
              itemBuilder: (context, index) {
                return StopwatchCard(
                    task: state.uncompletedTasks[index],
                    color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(160)
                );
              },
              separatorBuilder: (context, index) => const Gap(4),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => {_newStopwatch()},
        child: const Icon(Icons.add),
      ),
    );

  }
}
