import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/constants/images.dart';
import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:classwix_orbit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.5;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _scale = 1.0;
      });
    });
    Future.delayed(const Duration(seconds: 2), () {
      final String? authToken = ref.read(sampleProvider);
      logger.d("in splash: $authToken ");

      final initialRoute = authToken == null ? Routes.signin : Routes.homePage;

      Navigator.of(context)
          .pushNamedAndRemoveUntil(initialRoute, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _opacity,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  AppImages.splashLogo,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
