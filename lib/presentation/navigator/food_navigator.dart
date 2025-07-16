import 'package:flutter/material.dart';
import '../screen/food_screen/food_screen.dart';
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

          case '/catalog':
            // arguments は Map にして category と initialSelection を一緒に渡す
            final args = settings.arguments as Map<String, dynamic>;
            final dishCategory = args['dishCategory'] as String;
            final initialSelection =
                args['initialSelection'] as List<String>? ?? [];

            builder =
                (context) => DishCatalogScreen(
                  dishCategory: dishCategory,
                  initialSelection: initialSelection,
                );
            break;

          default:
            builder = (context) => const FoodScreen();
        }

        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
