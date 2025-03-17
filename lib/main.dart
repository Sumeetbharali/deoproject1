import 'package:classwix_orbit/core/themes/theme.dart';
import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/route_generator.dart';
import 'routes/routes.dart';
import 'package:flutter/services.dart';

var logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  logger.i("Initial Token: $token");
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const ProviderScope(
      child: MyApp(),
    ));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(sampleProvider); //load the token

    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
