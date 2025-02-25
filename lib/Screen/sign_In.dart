import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/constants/copies.dart';
import 'package:classwix_orbit/core/constants/images.dart';
import 'package:classwix_orbit/core/utils/widgets/custom_snack_bar.dart';
import 'package:classwix_orbit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

//correct
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final authController = ref.read(authProvider.notifier);

    bool success = await authController.login(
      _phoneController.text.trim(),
      _passwordController.text.trim(),
      ref,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      CustomSnackBar.showSnackBar(
          context, "You are successfully logged in", SnackBarType.success);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.homePage, (route) => false);
    } else {
      setState(() {
        _errorMessage = AppCopies.userNotFound;
      });
    }
  }

  Widget _buildTextField(
      IconData icon, String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        suffixIcon: Icon(
          obscureText ? Icons.lock : Icons.phone,
          color: Colors.grey.shade400,
        ),
      ),
      inputFormatters: [
        if (!obscureText) FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                AppImages.backgroundImg,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.only(top: 310),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      AppCopies.signIntext,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(
                        Icons.phone, AppCopies.phone, _phoneController),
                    const SizedBox(height: 15),
                    _buildTextField(
                        Icons.lock, AppCopies.password, _passwordController,
                        obscureText: true),
                    if (_errorMessage.isNotEmpty) const SizedBox(height: 25),
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 25),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Container(
                            width: double.infinity,
                            height: 50,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.4, 0.8],
                                colors: [
                                  Color.fromARGB(255, 0, 0, 139),
                                  Color.fromARGB(255, 65, 105, 225),
                                ],
                              ),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                overlayColor: Colors.white.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () => login(),
                              child: const Center(
                                child: Text(
                                  AppCopies.signIn,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.signup);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Don\'t have an account? ',
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Sign Up',
                                      style: TextStyle(
                                          color: AppColors.grad_blue,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                              AppCopies.signAsInstructor,
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//single_bottomsheet 
// import 'dart:math';

// import 'package:classwix_orbit/core/constants/copies.dart';
// import 'package:classwix_orbit/core/constants/images.dart';
// import 'package:classwix_orbit/routes/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../controller/auth_controller.dart';

// class SignInScreen extends ConsumerStatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   ConsumerState<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends ConsumerState<SignInScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _showSignInSheet(context);
//     });
//   }

//   Future<void> login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     final authController = ref.read(authProvider.notifier);

//     bool success = await authController.login(
//       _phoneController.text.trim(),
//       _passwordController.text.trim(),
//     );

//     setState(() {
//       _isLoading = false;
//     });

//     if (success) {
//       Navigator.of(context)
//           .pushNamedAndRemoveUntil(Routes.homePage, (route) => false);
//     } else {
//       setState(() {
//        logger.e("User Not Found");
//         _errorMessage = AppCopies.userNotFound;
//       });
//     }
//   }

//   Widget _buildSignInSheet() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             "Sign in to your account",
//             style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//           ),
        
//           const SizedBox(height: 15),
//           _buildTextField(Icons.phone, "Phone Number", _phoneController),
//           const SizedBox(height: 15),
//           _buildTextField(Icons.lock, "Password", _passwordController,
//               obscureText: true),
//           const SizedBox(height: 25),
//             const SizedBox(height: 10),
//           if (_errorMessage.isNotEmpty)
//             Text(
//               _errorMessage,
//               style: const TextStyle(
//                   color: Colors.red, fontWeight: FontWeight.bold),
//             ),

//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.only(left: 200.0,top: 30),
//                   child: GestureDetector(
//                     onTap: () => login(),
//                     child: Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(25)),
//                         gradient: LinearGradient(
//                           begin: Alignment.bottomLeft,
//                           end: Alignment.topRight,
//                           stops: [0.4, 0.8],
//                           colors: [
//                             Color.fromARGB(255, 0, 0, 139),
//                             Color.fromARGB(255, 65, 105, 225),
//                           ],
//                         ),
//                       ),
//                       alignment: Alignment.center,
//                       child: const Text(
//                         "Sign In",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//           const SizedBox(height: 100),

//           // Align the "Sign in as an Instructor" button to the center
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: TextButton(
//               onPressed: () {},
//               child:  Text(
//                 "Sign in as an Instructor",
//                 style: TextStyle(fontSize: 16,
//                   color: Colors.blueGrey.shade300,),
                
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSignInSheet(BuildContext context) {
//     showModalBottomSheet(

//       context: context,
//       isScrollControlled:
//           true, // Allows you to control the height of the bottom sheet
//       enableDrag: false, // Disables dragging the bottom sheet
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(42),
//           topRight: Radius.circular(42),
//         ),
//       ),
//       backgroundColor: Colors.transparent, // Makes the background transparent
//       builder: (context) {
//         return WillPopScope(
//           onWillPop: () async =>
//               false, // Disables the back button to prevent closing
//           child: Container(
//         height: 550, // Set the height to whatever you need
//         child: _buildSignInSheet(), // Custom widget for the sheet content
//       ),
//         );
//       },
//     );
  
//   }

//   Widget _buildTextField(
//       IconData icon, String hintText, TextEditingController controller,
//       {bool obscureText = false}) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(
//           fontWeight: FontWeight.normal,
//           color: Colors.grey,
//         ),
//         suffixIcon: Icon(
//           obscureText ? Icons.lock : Icons.phone,
//           color: Colors.grey.shade400,
//         ),
//       ),
//       inputFormatters: [
//          if (!obscureText) 
//         FilteringTextInputFormatter.digitsOnly,
//       LengthLimitingTextInputFormatter(10),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//       ),
//       body: Stack(
//         children: [
//           Image.asset(
//             AppImages.backgroundImg,
//             width: double.infinity,
//             height: double.infinity,
//             alignment: Alignment.topCenter,
//             fit: BoxFit.contain,
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'package:classwix_orbit/core/constants/images.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'components/onboard_content.dart';

// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   bool _isBottomSheetOpen = false;

//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(Duration.zero, () {
//       if (mounted) {
//         _isBottomSheetOpen = true;
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           enableDrag: false,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(42),
//               topRight: Radius.circular(42),
//             ),
//           ),
//           builder: (_) => WillPopScope(
//             onWillPop: () async => false,
//             child: const OnboardContent(),
//           ),
//         ).whenComplete(() {
//           _isBottomSheetOpen = false;

//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     if (_isBottomSheetOpen) {
//       Navigator.of(context).pop();

//     }
//     super.dispose();
//   }

//   @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(

//           backgroundColor: Colors.transparent,
//           systemOverlayStyle: SystemUiOverlayStyle.light,
//         ),
//         body: Image.asset(
//           AppImages.backgroundImg,
//           width: double.infinity,
//           fit: BoxFit.cover,
//         ),
//       );
//   }
// }











