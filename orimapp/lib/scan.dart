



import 'package:flutter/material.dart';
import 'package:orimapp/firs.dart';
import 'package:orimapp/home.dart';
import 'package:orimapp/second.dart';


void main() {
  runApp(ccc());
}

class ccc extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ccc> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MainPage()));
          }, icon: Icon(Icons.arrow_back)),
          backgroundColor: const Color.fromARGB(255, 229, 224, 239),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.qr_code,
                  size: 40,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.qr_code_scanner,
                  size: 40,
                ),
              ),
            ],
          ),
          title: Text(
            '  QR / Barcode Scanner',
          ),
        ),
        body: TabBarView(
          children: [
            First(),
            QRScannerPage()
          ],
        ),
      ),
    );
  }
}




