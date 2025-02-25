import 'package:classwix_orbit/core/themes/theme.dart';
import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes/route_generator.dart';
import 'routes/routes.dart';

var logger = Logger();

// void main()
// {
//    WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//   MaterialApp(
//     home: HomeScreen(),
//   ));
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  logger.i("Initial Token: $token");

  runApp(
     ProviderScope(
      child: MyApp(tkn: token),
      // child: HomeScreen(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final String? tkn;
  const MyApp({required this.tkn, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleToken = ref.watch(sampleProvider);
    logger.i("User login status token: $tkn and $sampleToken");

    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
