import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/states/global_state.dart';

import 'task_card.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key,});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      GlobalState state = Provider.of<GlobalState>(context, listen: false);
      state.title = "History";
      state.fab = null;
      state.showBottomNavBar = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
        builder: (context, state, child) {
          return ListView.builder(
              itemCount: state.taskHistory.length,
              itemBuilder: (context, index) {
                return TaskCard(task: state.taskHistory[index]);
              });
        }
    );
  }
}
