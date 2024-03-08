import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/TaskEntityListElement.dart';
import 'package:time_tracker/states/global_state.dart';
import 'package:time_tracker/projects/data/task_entity.dart';
import 'package:time_tracker/projects/presentation/add_projectPage.dart';
import 'package:time_tracker/stopwatch/StopwatchCard.dart';

import 'MyStopwatch.dart';


class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key,});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  List<MyStopwatch> _stopwatches = List.empty(growable: true);


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
    print("StopwatchPage.newStopwatch: called()");
    _stopwatches.add(MyStopwatch.upwards());
    setState(() {});
  }

  @override
  Widget build(BuildContext buildContext) {
    print("StopwatchPage.build: called()");
    // This method is rerun every time setState is called, for instance as done
    return ListView.separated(
        itemCount: _stopwatches.length,
        itemBuilder: (context, index) => StopwatchCard(stopwatch: _stopwatches[index]),
        separatorBuilder: (context, index) => const Divider(),
      );
  }
}
