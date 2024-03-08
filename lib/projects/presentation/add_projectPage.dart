import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/states/global_state.dart';


class AddProjectPage extends StatefulWidget {
  // final Callback<FloatingActionButton?> setFabCallback;


  const AddProjectPage({super.key,});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  @override
  void initState() {
    super.initState();

    GlobalState state = Provider.of<GlobalState>(context, listen: false);
    state.title = "Add Project";
    state.fab = null;
    state.showBottomNavBar = false;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    return Consumer<GlobalState>(
        builder: (context, value, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium,
                ),
                MaterialButton(onPressed: _incrementCounter),

              ],
            ),
          );
        }
    );
  }
}
