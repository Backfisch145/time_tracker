import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/stopwatch/MyStopwatch.dart';
import 'package:time_tracker/projects/data/task_entity.dart';
import 'package:time_tracker/projects/data/task_execution_entity.dart';
import 'package:time_tracker/states/global_state.dart';
import 'package:time_tracker/utils/DurationHelper.dart';

import 'components/ExpandableCard.dart';

class TaskListTile extends StatefulWidget {
  final int index;

  const TaskListTile({super.key, required this.index});

  @override
  State<TaskListTile> createState() => _TaskListTile();
}

class _TaskListTile extends State<TaskListTile> {
  TextEditingController? _controller;
  final MyStopwatch _stopwatch = MyStopwatch.upwards();

  Color? getBackground(BuildContext context) {
    if (widget.index % 2 == 1) {
      return Theme.of(context)
          .listTileTheme
          .copyWith(tileColor: Theme.of(context).colorScheme.surfaceVariant)
          .tileColor;
    }
    return Theme.of(context).listTileTheme.tileColor;
  }

  @override
  void initState() {
    print("TaskListTile.initState: called()");
    super.initState();
    GlobalState state = Provider.of<GlobalState>(context, listen: false);
    _controller = TextEditingController(text: state.tasks[widget.index].name);

    // _stopwatch.getStream().listen((duration) {
    //   setState(() {
    //     uiDuration = duration;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Consumer<GlobalState>(builder: (context, state, child) {
        TaskEntity task = state.tasks[widget.index];

        return ListenableBuilder(
            listenable: _stopwatch,
            builder: (context, child) {
              return ExpandableCard(
                  title: buildTitle(task, _stopwatch.duration, state.tasks),
                  expandableChildren: task.taskExecutions
                      .map((e) => Builder(
                          builder: (context) => Text(
                              "Start: ${e.start}\nDuration: ${printDuration(e.duration)}")))
                      .toList(),
                  trailing: ElevatedButton.icon(
                    onPressed: () => {
                      if (!_stopwatch.isRunning()){
                        _stopwatch.start(),
                        state.manualNotify()
                      } else {
                        _stopwatch.stop(),
                        task.taskExecutions.add(
                            TaskExecutionEntity.withDuration(
                                _stopwatch.duration)),
                        _stopwatch.reset(),
                        state.manualNotify()
                      }
                    },
                    icon: (!_stopwatch.isRunning())
                        ? const Icon(Icons.start)
                        : const Icon(Icons.stop),
                    label: (!_stopwatch.isRunning())
                        ? const Text("Start")
                        : const Text("Stop"),
                  ));
            });
      });
    } catch (a) {
      print("buildListEntry: ERROR - $a");
      rethrow;
    }
  }

  Widget buildTitle(TaskEntity currentTask, Duration duration, List<TaskEntity> allTasks) {
    print("TaskEntityListElement.buildTitle: duration=$duration");
    List<Widget> content = List.empty(growable: true);

    if (_stopwatch.isRunning()) {
      String durationStr = "(";
      durationStr += printDuration(duration);
      durationStr += ")";
      content.add(Text(
        durationStr,
        style: Theme.of(context).textTheme.titleMedium,
      ));
    }

    content.add(SizedBox(
      width: 480,
      child: TextField(
        controller: _controller,
        onChanged: (s) => {currentTask.name = s},
        autofillHints: allTasks.map((e) => e.name),
        decoration: const InputDecoration(
            hintText: "Name your Task", border: OutlineInputBorder()),
      ),
    ));

    // content.add(Text(currentTask.name));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: content,
    );
  }

// IconButton getExpandButton() {
//   Icon i = expanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more);
//   return IconButton(onPressed: () => {setExpanded(!expanded), f.call()}, icon: i);
// }
}
