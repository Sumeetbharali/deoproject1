import 'package:classwix_orbit/controller/auth_controller.dart';
import 'package:classwix_orbit/core/constants/copies.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/routes.dart';
import 'landed_content.dart';
import 'sing_up_form.dart';


class OnboardContent extends ConsumerStatefulWidget {
  const OnboardContent({super.key});

  @override
  _OnboardContentState createState() => _OnboardContentState();
}

class _OnboardContentState extends ConsumerState<OnboardContent> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  late PageController _pageController;

  var logger = Logger();

  @override
  void initState() {
        

    _pageController = PageController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

 @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }


  // Function to authenticate user and store data in SharedPreferences
  Future<void> login(String phone, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';  
    });

    final authController = ref.read(authProvider.notifier);

    bool success = await authController.login(
      _phoneController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {


      Navigator.of(context).pushNamedAndRemoveUntil(Routes.homePage, (route) => false);
      
    } else {
      
      setState(() {
        logger.e("User Not Found");
        _errorMessage = AppCopies.userNotFound;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        _pageController.hasClients ? (_pageController.page ?? 0) : 0;

    return SizedBox(
      height: 400 + progress * 160,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    const LandingContent(),
                    SignInForm(
                      errorMessage: _errorMessage,
                      passwordController: _passwordController,
                      phoneController: _phoneController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            height: 56,
            bottom: 48 + progress * 180,
            right: 16,
            child: GestureDetector(
              
              onTap: () async {
                if (_pageController.page == 0) {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease);
                } else {
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : login(_phoneController.text.trim(),
                          _passwordController.text.trim());
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.4, 0.8],
                    colors: [
                      Color.fromARGB(255, 0, 0, 139),
                      Color.fromARGB(255, 65, 105, 225)
                    ],
                  ),
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 92 + progress * 32,
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            FadeTransition(
                              opacity: AlwaysStoppedAnimation(1 - progress),
                              child: const Text("Get Started"),
                            ),
                            FadeTransition(
                              opacity: AlwaysStoppedAnimation(progress),
                              child: const Text(
                                "Sign In",
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



class Myhome extends StatelessWidget {
  const Myhome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body: Text('home'),
    );
  }
}