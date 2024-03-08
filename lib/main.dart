import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/favourites/presentation/favouritesPage.dart';
import 'package:time_tracker/history/presentation/historyPage.dart';
import 'package:time_tracker/projects/presentation/projectPage.dart';
import 'package:time_tracker/stopwatch/stopwatch_page.dart';

import 'states/global_state.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => GlobalState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker\n Fabian Jäger 349405',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Page {
  FAVOURITES(icon: Icons.star),
  PROJECTS(icon: Icons.event_note),
  HISTORY(icon: Icons.history);

  final IconData icon;

  const Page({required this.icon});
}

class _MyHomePageState extends State<MyHomePage> {
  Page selectedPage = Page.PROJECTS;

  void _setSelectedPage(Page selectedPage) {
    setState(() {
      this.selectedPage = selectedPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    return Consumer<GlobalState>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(value.title),
        ),
        body: switch (selectedPage) {
          Page.PROJECTS => const StopwatchPage(),
          // Page.PROJECTS => const ProjectPage(),
          Page.FAVOURITES => const FavouritesPage(),
          Page.HISTORY => const HistoryPage(),
        },
        floatingActionButton: value.fab,
        bottomNavigationBar: Visibility(
          visible: value.showBottomNavBar,
          child: BottomNavigationBar(
            items: Page.values
                .map((e) =>
                BottomNavigationBarItem(label: e.name, icon: Icon(e.icon)))
                .toList(),
          onTap: (pos) => {_setSelectedPage(Page.values[pos])},
          currentIndex: Page.values.indexOf(selectedPage),
        )),
      ),
    );
  }
}
