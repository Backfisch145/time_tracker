import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/TaskEntityListElement.dart';
import 'package:time_tracker/states/global_state.dart';
import 'package:time_tracker/projects/data/task_entity.dart';
import 'package:time_tracker/projects/presentation/add_projectPage.dart';


class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key,});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  void addProject(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddProjectPage()));
  }


  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      GlobalState state = Provider.of<GlobalState>(context, listen: false);
      state.title = "Projects";
      state.showBottomNavBar = true;
      state.fab = FloatingActionButton(
        onPressed: () => addProject(context),
        child: const Icon(Icons.add),
      );
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    // This method is rerun every time setState is called, for instance as done
    return Consumer<GlobalState>(
        builder: (context, value, child) {
          if ((value.tasks.isEmpty)) {
            return const Text("NO entrys");
          } else {
            return ListView.builder (
                itemCount: value.tasks.length,
                itemBuilder: (context, index) => TaskListTile(index: index)
            );
          }
        },
    );
  }
}
