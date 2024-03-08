import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/states/global_state.dart';


class HistoryPage extends StatefulWidget {
  // final Callback<FloatingActionButton?> setFabCallback;


  const HistoryPage({super.key,});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


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
                MaterialButton(onPressed: _incrementCounter)
              ],
            ),
          );
        }
    );
  }
}
