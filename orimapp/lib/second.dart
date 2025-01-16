import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void main() => runApp(MaterialApp(home: QRScannerPage()));

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String scannedResult = "QR / Barcode kodini skanerlash uchun kamerani yo'naltiring.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR / Barcode Scanner'),
        backgroundColor: const Color.fromARGB(255, 229, 224, 239),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scannedResult,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navigate to the scanner screen and wait for the result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ),
                );

                // Update the result when scanning is complete
                if (result != null) {
                  setState(() {
                    scannedResult = "Skanlangan Kod: $result";
                  });
                }
              },
              child: Text('QR / Barcode Skanerini Ochish'),
              style: ElevatedButton.styleFrom(
            
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
