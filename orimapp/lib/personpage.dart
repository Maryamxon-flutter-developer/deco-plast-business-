import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:orimapp/aboutapp.dart';


class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  // Telegram va Instagram URL manzillari
  final Uri _telegramUrl = Uri.parse("https://t.me/orimapp");
  final Uri _instagramUrl = Uri.parse("https://www.instagram.com/orimapp?igsh=MTlsaHJzcXdhbzlxNw==");

  // Havolani ochish funksiyasi (yangi sintaksis)
  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Havola ochilmadi: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 202, 168, 230),
        leading: IconButton(
          onPressed: () {
          Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 202, 168, 230),
      body: Center(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 234, 226, 241),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 70,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Lider",
              style: GoogleFonts.lobster(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(237, 65, 64, 64),
              ),
            ),
            const SizedBox(height: 20),

            // Ilova haqida
            _buildMenuItem("Ilova haqida", Icons.arrow_forward_ios, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutApp()));
            }),

            // Biz bilan bog'lanish
            _buildMenuItem("Biz bilan bog'lanish", Icons.arrow_forward_ios, () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Telegram va Instagram tugmalari
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton("assets/tel.png", _telegramUrl),
                            const SizedBox(width: 15),
                            _buildSocialButton("assets/ing.webp", _instagramUrl),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Bekor qilish tugmasi
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Bekor qilish'),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // Menyu elementi
  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Icon(icon, color: const Color.fromARGB(255, 63, 63, 63)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Telegram va Instagram tugmalari
  Widget _buildSocialButton(String assetPath, Uri url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
