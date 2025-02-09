
import 'package:classwix_orbit/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (mounted) {
        _isBottomSheetOpen = true;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(42),
              topRight: Radius.circular(42),
            ),
          ),
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: const OnboardContent(),
          ),
        ).whenComplete(() {
          _isBottomSheetOpen = false; 
          
        });
      }
    });
  }

  @override
  void dispose() {
    if (_isBottomSheetOpen) {
      Navigator.of(context).pop(); 

    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Image.asset(
        AppImages.backgroundImg,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
