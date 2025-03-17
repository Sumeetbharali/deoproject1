import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/constants/copies.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperinfoWidget extends StatelessWidget {
  const DeveloperinfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Developed by",
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Hari Hara Sudhan\nKGISL Institute of Technology\nCoimbatore, Tamil Nadu",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppCopies.developerContact,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          _buildLink(
              "🔗 LinkedIn", AppCopies.linkedinLink),
          _buildLink("💻 GitHub", AppCopies.githubLink),
        ],
      ),
    );
  }
}

void _launchURL(link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildLink(String label, String link) {
    return GestureDetector(
      onTap: () => _launchURL(link),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.blueAccent,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
