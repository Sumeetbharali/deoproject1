import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomGeneralcard extends ConsumerWidget {
  final String title;
  final IconData icon;
  const CustomGeneralcard({required this.title, required this.icon, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currentToken = ref.read(authServiceProvidere.notifier).getuserData();

    return ListTile(
      title: Text(title),
      trailing: Icon(icon, color: Colors.purple),
      onTap: () async {
        if (title == 'Forget Password' || title == 'Change Password') {
          try {
            // await FirebaseAuth.instance
            //     .sendPasswordResetEmail(email: currentToken['email']);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //       content: Text("Password reset email sent Successfully!!")),
            // );
          } catch (e) {
            // CustomSnackBar.showSnackBar(
            //   context,
            //   "Error Sending Request : Check Internet",
            //   SnackBarType.failure,
            // );
          }
        } else if (title == 'Terms & Conditions') {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const TermsOfService()));
        } else {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
          // );
        }
      },
    );
  }
}
