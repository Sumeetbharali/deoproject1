import 'package:classwix_orbit/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/auth_controller.dart';
import 'routes/route_generator.dart';
import 'routes/routes.dart';

var logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  logger.i("Initial Token: $token");

  runApp(
    ProviderScope(
      child: MyApp(tkn: token),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final String? tkn;
  const MyApp({required this.tkn, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.i("User login status token: $tkn");
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: tkn == null ? Routes.initial : Routes.homePage,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
