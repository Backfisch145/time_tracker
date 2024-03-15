import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/data/boxes.dart';
import 'package:time_tracker/states/global_state.dart';
import 'package:time_tracker/data/task.dart';
import 'package:time_tracker/stopwatch/stopwatch_card.dart';

import 'my_stopwatch.dart';


class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key,});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  // final List<MyStopwatch> _stopwatches = List.empty(growable: true);


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      GlobalState state = Provider.of<GlobalState>(context, listen: false);
      state.title = "Stopwatches";
      state.showBottomNavBar = true;
      state.fab = FloatingActionButton(
        onPressed: () => {newStopwatch()},
        child: const Icon(Icons.add),
      );
    });
  }

  void newStopwatch() {
    if (kDebugMode) {
      print("StopwatchPage.newStopwatch: called()");
    }
    var task = Task();
    GlobalState state = Provider.of<GlobalState>(context, listen: false);
    MyStopwatch sw = MyStopwatch.upwards(task: task);
    state.stopwatches.add(sw);
    taskBox.put(sw.task.id, sw.task);
    state.manualNotify();
  }

  @override
  Widget build(BuildContext buildContext) {
    if (kDebugMode) {
      print("StopwatchPage.build: called()");
    }
    return Consumer<GlobalState>(
      builder: (context, state, child) {
        return ListView.separated(
          itemCount: state.stopwatches.length,
          itemBuilder: (context, index) => StopwatchCard(
            stopwatch: state.stopwatches[index],

          ),
          separatorBuilder: (context, index) => const Gap(16),
        );
      },
    );

  }
}
