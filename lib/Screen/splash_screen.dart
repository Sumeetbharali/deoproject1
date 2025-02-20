import 'package:classwix_orbit/controller/auth_controller.dart';
import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:classwix_orbit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final sampleToken = ref.watch(sampleProvider);
//       logger.d("in splash: and ${sampleToken}");

//     SharedPreferences.getInstance().then((prefs) {
//       final String? authState = prefs.getString('token');
//       logger.i(authState);

//       final initialRoute = authState == null ? Routes.signin : Routes.homePage;
//       Future.delayed(const Duration(seconds: 3), () {
//         Navigator.of(context)
//             .pushNamedAndRemoveUntil(initialRoute, (route) => false);
//       });
//     });

//     // Future.delayed(const Duration(seconds: 2), () {
//     //   if (mounted) {
//     //     Navigator.push(context, MaterialPageRoute(builder: (context)=> token.toString() == null ?  Routes.initial : Routes.homePage)
//     //     );
//     //   }
//     // });
//     // final initialRoute = authState == null ? Routes.login : Routes.homePage;
//     // Future.delayed(const Duration(seconds: 3), () {
//     //   Navigator.of(context) .pushNamedAndRemoveUntil(initialRoute, (route) => false);
//     // });
//   }
//   // void initState() {
//   //   super.initState();
//   //   _checkLoginStatus();
//   // }

//   // Future<void> _checkLoginStatus() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final String? token = prefs.getString('token');

//   //   Future.delayed(const Duration(seconds: 2), () {
//   //     if (mounted) {
//   //       Navigator.push(context, MaterialPageRoute(builder: (context)=> token.toString() == null ?  Routes.initial : Routes.homePage)
//   //       );
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: CircularProgressIndicator(
//           backgroundColor: Colors.blue,
//         ), // Show loading indicator
//       ),
//     );
//   }
// }


//if this code not works uncommand above code and comment this code
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
