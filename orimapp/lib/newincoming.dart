
import 'package:flutter/material.dart';


class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  double _imageSize = 200.0;  // Boshlang'ich rasm o'lchami
  bool _isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: Text("Hujjatlar"),
  backgroundColor: const Color.fromARGB(255, 229, 224, 239),
  leading: IconButton(
    onPressed: () {
      Navigator.pop(context); // Goes back to the previous screen
    },
    icon: Icon(Icons.arrow_back, color: Colors.black), // Customize color if needed
  ),
),

      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              // Animatsiya boshlanadi yoki to'xtaydi
              _isAnimating = !_isAnimating;
              _imageSize = _isAnimating ? 400.0 : 200.0;  // Rasmni kattalashtirish
            });
          },
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut, // Animatsiyaning silliqligi
            width: _imageSize,
            height: _imageSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://cdni.iconscout.com/illustration/premium/thumb/businessman-sad-for-no-data-in-folder-illustration-download-svg-png-gif-file-formats--empty-business-work-pack-illustrations-10155562.png?f=webp"),
                fit: BoxFit.cover,  // BoxFit qo'shildi
              ),
            ),
          ),
        ),
      ),
    );
  }
}
