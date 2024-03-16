import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/states/task_state.dart';

import 'task_card.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key,});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  Widget build(BuildContext context) {

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
        leading: BackButton(
          color: onAppBarColor
        )
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/background.jpg"), fit: BoxFit.cover),
        ),
        child: Consumer<TaskState>(
            builder: (context, state, child) {
              return ListView.builder(
                  itemCount: state.completedTasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(task: state.completedTasks[index]);
                  });
            }
        )
      ),
    );
  }
}
