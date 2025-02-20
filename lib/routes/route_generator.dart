import 'package:classwix_orbit/Screen/sign_up.dart';
import 'package:classwix_orbit/Screen/splash_screen.dart';

import '../Screen/hidden_drawer.dart';
import 'package:flutter/material.dart';
import '../Screen/sign_In.dart';
import '../error/screen.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.signin:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
       case Routes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HiddenDrawer());

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
