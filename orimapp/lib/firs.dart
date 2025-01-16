import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  TextEditingController title = TextEditingController();
  String code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: title,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Code',
                  ),
                ),
              ),
              MaterialButton(
                color:  const Color.fromARGB(255, 229, 224, 239),
                onPressed: () {
                  setState(() {
                    code = title.text;
                  });
                },
                child: Text(
                  "Create QR Code",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 82, 81, 81),
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (code.isNotEmpty)
                BarcodeWidget(
                  barcode: Barcode.qrCode(
                    errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                  ),
                  data: code,
                  width: 200,
                  height: 200,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
