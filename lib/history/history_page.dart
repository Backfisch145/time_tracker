import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/helper/duration_helper.dart';
import 'package:time_tracker/state/task_state.dart';

import '../main.dart';
import '../data/task.dart';
import 'history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  bool _hideZeroDuration = false;


  @override
  Widget build(BuildContext context) {
    Color appBarColor = Theme.of(context).colorScheme.primary;
    Color onAppBarColor = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("Historie",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          leading: BackButton(color: onAppBarColor),
        actions: [
          IconButton(
            onPressed: () => {
              setState(() {
                _hideZeroDuration = !_hideZeroDuration;
              })
            },
            icon: _hideZeroDuration ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
            color: onAppBarColor,
          )
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover),
          ),
          child: Consumer<TaskState>(
              builder: (context, state, child) {

                List<Task> eas = List.of(state.completedTasks.where((element) => (element.duration.inSeconds != 0) || !_hideZeroDuration));
                eas.sort((a, b) => a.completion!.isBefore(b.completion!)? 1 : 0);
                Map<String, List<Task>> taskDateMap = _mapTasksByDate(eas);
                List<String> keys = taskDateMap.keys.toList();

                return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, kexIndex) {
                    String key =keys[kexIndex];
                    int itemCount = 0;
                    if (taskDateMap[key] != null) {
                      itemCount = taskDateMap[key]!.length;
                    } else {
                      logger.w("Empty Maps entry on Key[$key]");
                    }

                  return Column(
                    children: [
                      _getTitle(key, taskDateMap[key]!),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: itemCount,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          Task t  = taskDateMap[key]![index];
                          return HistoryCard(
                            task: t,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withAlpha(220),
                          );
                        },
                      )
                    ],
                  );
              },
            );
          })),
    );
  }

  Map<String, List<Task>> _mapTasksByDate(List<Task> tasks) {
    Map<String, List<Task>> result = {};

    for (var element in tasks) {
      result.update(DateFormat('dd.MM.yyyy').format(element.completion!),
        (value) {
          try {
            value.add(element);
          } on Exception catch (_, e){
            logger.e(e);
          }
          return value;
        },
        ifAbsent: () {
          List<Task> newList = List.empty(growable: true);
          try {
            newList.add(element);
          } on Exception catch (_, e){
            logger.e(e);
          }
          return newList;
        },
      );
    }

    return result;
  }

  Widget _getTitle(String date, List<Task> list) {
    Duration totalDuration = Duration(
        seconds: list.fold(0, (previousValue, element) => previousValue + element.duration.inSeconds)
    );

    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            date,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary),
            textAlign: TextAlign.center,
          ),
          Text(
            printDurationLong(totalDuration),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onTertiary),
            textAlign: TextAlign.center,
        ),

      ]
      ),
    );
  }
}
