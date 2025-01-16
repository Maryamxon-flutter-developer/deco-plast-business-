import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:orimapp/home.dart';
import 'package:orimapp/registr.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // API'dan foydalanuvchi va parol ma'lumotlarini olish
    final response = await http.get(
      Uri.parse('https://dash.vips.uz/api/49/7603/84312'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      // API'dan kelgan ma'lumotlarni tekshirish
      for (var item in jsonData) {
        if (item["user"] == username && item["parol"] == password) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
          return;
        }
      }
    }

    // Agar login yoki parol noto'g'ri bo'lsa
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login yoki parol noto‘g‘ri!"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RejestrPage()),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        
         
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 230,
                height: 230,
                child: Image.asset("assets/gif.gif", fit: BoxFit.cover),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Color(0xFFE494F4)),
                  labelText: "Shaxsiy loginingizni kiriting",
                  labelStyle: TextStyle(color: Color(0xFF615F61)),
                  filled: true,
                  fillColor: Color(0xFFF6F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE494F4), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFFE494F4)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFFE494F4),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  labelText: "Parolingizni kiriting",
                  labelStyle: TextStyle(color: Color(0xFF4A484B)),
                  filled: true,
                  fillColor: Color(0xFFF5F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE494F4), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Color(0xFFE494F4),
                ),
                child: Text("Kirish", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _register,
                child: Text(
                  "Ro'yxatdan o'tish",
                  style: TextStyle(fontSize: 14, color: Color(0xFF474547), decoration: TextDecoration.underline),
                ),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset("assets/ORIM.jpg", fit: BoxFit.cover),
                  ),
                  Container(width: 2, height: 50, color: Color(0xFF424141)),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Text("ORIM APP", style: TextStyle(fontWeight: FontWeight.w700)),
                      Text("COMPANY", style: TextStyle(color: Color(0xFFD271EA), fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
