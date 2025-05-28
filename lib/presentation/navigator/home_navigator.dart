import 'package:flutter/material.dart';
import '../screen/home_screen/home_screen.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (context) => const HomeScreen();
            break;
          default:
            builder = (context) => const HomeScreen();
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
