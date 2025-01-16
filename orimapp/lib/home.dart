import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clay_containers/clay_containers.dart';

import 'package:orimapp/categorysahifa.dart';
import 'package:orimapp/document.dart';
import 'package:orimapp/newincoming.dart';

import 'package:orimapp/qarzt.dart';
import 'package:orimapp/scan.dart';
import 'package:orimapp/store.dart';
import 'package:orimapp/yetkazibberuvchi.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedLanguage = 'uz';

  final Map<String, Map<String, String>> localizedValues = {
    'en': {
      'title': 'ORIM',
      'goods': 'Goods',
      'stores': 'Warehouse',
      'qr_code': 'QR Barcode',
      'incoming': 'Sales Section',
      'suppliers': 'Suppliers',
      'documents': 'Documents',
    },
    'uz': {
      'title': 'ORIM',
      'goods': 'Tovarlar',
      'stores': 'Ombor',
      'qr_code': 'QR Barcode',
      'incoming': 'Sotuv bo`limi',
      'suppliers': 'Yetkazib beruvchilar',
      'documents': 'Hujjatlar',
    },
  };

  String getLocalizedText(String key) {
    return localizedValues[selectedLanguage]?[key] ?? key;
  }

  void navigateToPage(int index) {
    Widget page;
    switch (index) {
      case 0:
        page = Categoriya();
        break;
      case 1:
        page = DocsexTable();
        break;
      case 2:
        page = ccc();
        break;
      case 3:
        page = SalesPage();
        break;
      case 4:
        page = UserListPage();
        break;
      case 5:
        page = MyWidget();
        break;
      default:
        page = MyWidget();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color.fromARGB(255, 190, 89, 241),
               const Color.fromARGB(255, 212, 156, 240),
             const Color.fromARGB(255, 35, 33, 36)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            getLocalizedText('title'),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30,
              color: Colors.white, // Gradient ishlashi uchun color beriladi
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 20,
        actions: [
          IconButton(
            icon: Icon(Icons.attach_money, color: Colors.black,size: 30,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> QarzPage()));
              // Setting bosilganda nima qilish kerak bo'lsa yozasiz
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedLanguage = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'uz', child: Text('O‘zbek')),
              PopupMenuItem(value: 'en', child: Text('English')),
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CarouselSlider(
                items: [
                  Image.asset("assets/hui.jpg"),
                  Image.asset("assets/ORIM.jpg"),
                  Image.asset("assets/mm.png"),
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 19 / 8,
                  viewportFraction: 0.8,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(6, (index) {
                  return ClayContainerWidget(
                    index: index,
                    getLocalizedText: getLocalizedText,
                    onTap: () => navigateToPage(index),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClayContainerWidget extends StatelessWidget {
  final int index;
  final String Function(String) getLocalizedText;
  final VoidCallback onTap;

  const ClayContainerWidget({
    Key? key,
    required this.index,
    required this.getLocalizedText,
    required this.onTap,
  }) : super(key: key);

  static const List<IconData> _icons = [
    Icons.shopping_bag,
    Icons.store,
    Icons.qr_code,
    Icons.inbox,
    Icons.people,
    Icons.document_scanner,
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClayAnimatedContainer(
        height: 160,
        width: 175,
        depth: 45,
        borderRadius: 10,
        color: Color.fromARGB(255, 207, 194, 240),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_icons[index]),
              Text(getLocalizedText([
                'goods',
                'stores',
                'qr_code',
                'incoming',
                'suppliers',
                'documents',
              ][index])),
            ],
          ),
        ),
      ),
    );
  }
}
