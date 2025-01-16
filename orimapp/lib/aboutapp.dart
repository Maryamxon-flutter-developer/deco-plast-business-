import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // share_plus paketini import qiling

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ilova haqida"),
        backgroundColor: const Color.fromARGB(255, 177, 120, 223),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // iOS orqaga ikonkasi
          onPressed: () {
            Navigator.pop(context); // Orqaga qaytish
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ilova rasmi
            Center(
              child: Image.asset(
                "assets/ORIM.jpg", fit: BoxFit.cover,// Rasmingizni assets folderga joylashtiring
                height: 120,
              ),
            ),
            const SizedBox(height: 16),

            // Ilova tavsifi
            const Text(
              "Bizning ilovamiz biznesingizni rivojlantirish va samaradorlikni oshirish uchun ishlab chiqilgan. "
              "Ilova yordamida do'koningiz samaradorligini, to‘lovlarni kuzatish va statistikalarni tahlil qilish mumkin.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Asosiy funksiyalar ro‘yxati
            const Text(
              "Asosiy funksiyalar:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Column(
              children: [
                featureItem(Icons.business, "Biznes jarayonlarini boshqarish"),
                featureItem(Icons.attach_money, "To‘lovlarni kuzatish va boshqarish"),
                featureItem(Icons.analytics, "Mijozlar va statistik ma’lumotlarni tahlil qilish"),
                featureItem(Icons.support_agent, "Mijozlarga tezkor xizmat ko‘rsatish"),
              ],
            ),
            const SizedBox(height: 20),

            
            const SizedBox(height: 20),

            // Share qilish
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.share), // iOS 'Share' ikonkasi
                  onPressed: () {
                    _shareApp();  // Share funksiyasini chaqirish
                  },
                ),
                const Text("Qollanma ulashish"),
              ],
            ),
            const SizedBox(height: 20),

           
          ],
        ),
      ),
    );
  }

  // Funksiya - har bir funksiyani alohida widget sifatida yaratish
  Widget featureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
  void _shareApp() {
  final String text = "Bizning ilovamizni sinab ko'ring: https://example.com"; // URL yoki matn
  Share.share(text, subject: "Ilova haqida ma'lumot"); // "subject" bilan qo'shimcha ma'lumot qo'shish
}


 
}
