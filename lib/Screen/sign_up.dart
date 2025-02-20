import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/constants/copies.dart';
import 'package:classwix_orbit/core/constants/images.dart';
import 'package:classwix_orbit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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
                      AppCopies.signUptext,
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Center(
                                child: Text(
                                  AppCopies.signUp,
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
                              Navigator.pop(context);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account?',
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Sign In',
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
