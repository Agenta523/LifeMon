import 'package:flutter/material.dart';
import '../screen/home_screen/home_screen.dart';

class HomeNavigator extends StatelessWidget {
  final GlobalKey<HomeScreenState> homeScreenKey;

  const HomeNavigator({super.key, required this.homeScreenKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (context) => HomeScreen(key: homeScreenKey);
            break;
          default:
            builder = (context) => HomeScreen(key: homeScreenKey);
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
