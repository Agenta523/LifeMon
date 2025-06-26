import 'package:flutter/material.dart';
import '../screen/food_screen/food_screen.dart';
import '../screen/food_screen/maindish_reg.dart';
import '../screen/food_screen/dish_catalog_screen.dart';

class FoodNavigator extends StatelessWidget {
  const FoodNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;

        switch (settings.name) {
          case '/':
            builder = (context) => const FoodScreen();
            break;
          case '/maindish':
            builder = (context) => const MainDishScreen();
            break;
          case '/catalog':
            // dishCategory を arguments から取得して渡す
            final dishCategory = settings.arguments as String;
            builder =
                (context) => DishCatalogScreen(dishCategory: dishCategory);
            break;
          default:
            builder = (context) => const FoodScreen();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
