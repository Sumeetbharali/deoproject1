import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:classwix_orbit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () { // change the sec to 3 when you implement the splash screen
    
      final String? authToken = ref.read(sampleProvider); 
      final String? authToken2 = ref.watch(sampleProvider);

      logger.d("in splash: and $authToken2 $authToken");

      final initialRoute = authToken == null ? Routes.signin : Routes.homePage;

      Navigator.of(context)
          .pushNamedAndRemoveUntil(initialRoute, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
