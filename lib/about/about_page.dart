import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Route _routeToLicences() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LicensePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                Text(
                    "Fabian Jäger\nMatr.: 349405",
                    style: Theme.of(context).textTheme.titleMedium
                ),
                const CircleAvatar(
                  radius: 256,
                  backgroundImage: AssetImage("assets/images/me.webp")
                ),
              ],
            ),
          ),

          const Gap(32),
          FilledButton(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description),
                Gap(8),
                Text("Libraries und Lizenzen")
              ],
            ),
            onPressed: () => {
              Navigator.push(
                  context,
                  _routeToLicences()
              )
            }),

          const Gap(32),

          Text(
              "Quellen für genutzte Bildern",
          style: Theme.of(context).textTheme.headlineMedium
          ),
          Card(
            child: Column(
              children: [
                Text(
                    "Benutzt für: AppIcon und Hintergrund",
                    style: Theme.of(context).textTheme.titleMedium
                ),
                const Image(image: AssetImage("assets/images/background.jpg"), ),
                const Text("source: https://pixabay.com/de/illustrations/sonnenaufgang-sonnenuntergang-w%C3%BCste-7326601/")
              ],
            ),
          )
          
        ],
      )
    );
  }
}