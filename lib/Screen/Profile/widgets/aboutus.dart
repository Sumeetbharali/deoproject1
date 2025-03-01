import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("About DeoLang"),
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
                "About DeoLang",
                style: GoogleFonts.lato(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Founded in Assam, India, DeoLang is a forward-thinking IT company committed to delivering high-quality software solutions. Our team of experienced developers, designers, and IT professionals work collaboratively to ensure that we meet and exceed our clients' expectations.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              _buildSection(
                title: "Our Vision",
                icon: Icons.visibility,
                description:
                    "To be a leading IT service provider, recognized for our innovative solutions and exceptional customer service.",
              ),

         
              _buildSection(
                title: "Our Mission",
                icon: Icons.rocket_launch,
                description:
                    "To empower businesses through technology by providing tailored software solutions that drive efficiency and growth.",
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
              _buildDeveloperInfo(),
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

  Widget _buildDeveloperInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Developed by",
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
            "📧 Contact: sudhanabirami007@gmail.com",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 10),
          _buildLink(
              "🔗 LinkedIn", "https://www.linkedin.com/in/hari-hara-sudhans/"),
          _buildLink("💻 GitHub", "https://github.com/HariHara-sn"),
        ],
      ),
    );
  }

  Widget _buildLink(String label, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri link = Uri.parse(url);
        if (await canLaunchUrl(link)) {
          await launchUrl(link, mode: LaunchMode.externalApplication);
        }
      },
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
}
