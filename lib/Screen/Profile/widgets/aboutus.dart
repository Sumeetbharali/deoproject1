import 'package:classwix_orbit/Screen/Profile/widgets/developerInfo_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/copies.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(AppCopies.aboutdeolang),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppCopies.aboutdeolang,
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppCopies.profiletext1,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              _buildSection(
                title: AppCopies.visiontxt,
                icon: Icons.visibility,
                description: AppCopies.visiondesc,
              ),

              _buildSection(
                title: AppCopies.missiontxt,
                icon: Icons.rocket_launch,
                description: AppCopies.missiondesc,
              ),

              _buildSection(
                title: "Our Values",
                icon: Icons.diamond,
                description: "",
                isList: true,
                values: [
                  "Innovation",
                  "Integrity",
                  "Customer",
                  "Focus",
                  "Excellence",
                ],
              ),

              const SizedBox(height: 30),
              const Divider(color: Colors.white24),
              const SizedBox(height: 10),

              // Developed By Section
              const DeveloperinfoWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String description,
    bool isList = false,
    List<String>? values,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.yellowAccent, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isList && values != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: values
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        "• $value",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }
}
