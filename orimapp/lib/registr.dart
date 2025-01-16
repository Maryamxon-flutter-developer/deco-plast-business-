import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RejestrPage extends StatefulWidget {
  const RejestrPage({super.key});

  @override
  State<RejestrPage> createState() => _RejestrPageState();
}

class _RejestrPageState extends State<RejestrPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  // Registration logic (API call)
  Future<void> _register() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;

    if (name.isNotEmpty && phone.isNotEmpty && password.isNotEmpty) {
      try {
        // Your API URL
        final apiUrl = 'https://dash.vips.uz/api/49/7603/83841'; // API URLni to'g'rilab qo'ying

        // Creating the body for the POST request
        Map<String, String> data = {
          'ismi': name,
          'telifonraqami': phone,
          'parol': password,
        };

        // Sending the POST request to the API
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: data, // Fix: Removed the json.encode, as form data should be sent as plain text
        );

        // Checking the response status code
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Registration successful
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Ro'yxatdan o'tish muvaffaqiyatli!"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // If the server responds with an error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Xatolik yuz berdi!"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Handling any exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internet aloqasi mavjud emas."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Iltimos, barcha maydonlarni to'ldiring!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 330,
                height: 230,
                child: Image.asset("assets/IN.gif", fit: BoxFit.cover),
              ),
              SizedBox(height: 30),
              // **Name Input Field**
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 228, 148, 244)),
                  hintText: "",
                  labelText: "Ismingizni kiriting",
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 97, 95, 97)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 246, 244, 244),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 228, 148, 244), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // **Phone Number Input Field**
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: const Color.fromARGB(255, 228, 148, 244)),
                  hintText: "998900000909",
                  labelText: "Telefon raqamingizni kiriting",
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 97, 95, 97)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 246, 244, 244),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 228, 148, 244), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // **Password Input Field**
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 228, 148, 244)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color.fromARGB(255, 228, 148, 244),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  hintText: "6 xonalik",
                  labelText: "Parolingizni kiriting",
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 74, 72, 75)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 245, 244, 244),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 228, 148, 244), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // **Register Button**
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color.fromARGB(255, 228, 148, 244),
                ),
                child: Text(
                  "Ro'yxatdan o'tish",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
