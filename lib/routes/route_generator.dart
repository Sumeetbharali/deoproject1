import '../Screen/components/hidden_drawer.dart';
import 'package:flutter/material.dart';
import '../Screen/Onboardingscreen.dart';
import '../error/screen.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) =>  OnboardingScreen());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HiddenDrawer());
      // builder: (_) => const Myhome());

      default:
        return _errorRoute();
      // return generateRoute(settings); //remove this and uncomment above
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const ErrorScreen(),
    );
  }
}
