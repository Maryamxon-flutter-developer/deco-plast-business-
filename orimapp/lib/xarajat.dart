import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class XarajatlarPage extends StatefulWidget {
  const XarajatlarPage({super.key});

  @override
  State<XarajatlarPage> createState() => _XarajatlarPageState();
}

class _XarajatlarPageState extends State<XarajatlarPage> {
  final List<Map<String, String>> shopData = [];
  bool isLoading = false;
///apidan malumot olinmoqda
  Future<void> fetchShopData() async {
    setState(() => isLoading = true);
    const String apiUrl = "https://dash.vips.uz/api/49/7603/82588";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          shopData.clear();
          shopData.addAll(data.map((item) => {
                'nomi': item['nomi'].toString(),
                'info': item['info'].toString(),
                'miqdori': item['miqdori'].toString(),
              }));
        });
      } else {
        throw Exception('API xatosi: ${response.statusCode}');
      }
    } catch (e) {
      print('Xatolik: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

 // Post Data to API
  Future<void> postData(String nomi,String info, String miqdori,) async {
    if (nomi.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, malumotlarni kiriting!"), backgroundColor: Colors.red),
      );
      return;
    }

    final String url = 'https://dash.vips.uz/api-in/49/7603/82588';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'nomi':nomi , 
          'info': info,
          'miqdori': miqdori,
        
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ma’lumot muvaffaqiyatli qo‘shildi!')),
        );
        fetchShopData(); // Ma’lumotlarni qayta yuklash
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ma’lumot qo‘shilmadi')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik yuz berdi')),
      );
    }
  }

  // Show Dialog for Posting Data
  void showPostDialog() {
   
     final TextEditingController nomiController = TextEditingController();
      final TextEditingController infoController = TextEditingController();
       final TextEditingController miqdoriController = TextEditingController();
     
  
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xarajatlarim'),
          content: Column(
             mainAxisSize: MainAxisSize.min,
            children: [
             TextField(
              controller: nomiController,
              decoration: InputDecoration(
                labelText: 'Xarajat nomi',

              ),

             ),
             TextField(
              controller: infoController,
              decoration: InputDecoration(
                labelText: 'qisqacha info',

              ),
             ),
              TextField(
              controller: miqdoriController,
              decoration: InputDecoration(
                labelText: 'xarajat miqdori',

              ),
             ),
             
            ],
          ),
          
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                postData(
                nomiController.text.trim(),
                infoController.text.trim(),
                miqdoriController.text.trim(),

                );
                Navigator.pop(context);
              },
              child: Text('Qo‘shish'),
            ),
          ],
        );
      },
    );
  }







  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  List<Color> customColors = [
    Colors.blue,   // 1-chi bo'lim uchun rang
    Colors.green,  // 2-chi bo'lim uchun rang
    Colors.red,    // 3-chi bo'lim uchun rang
    Colors.orange, // 4-chi bo'lim uchun rang
    const Color.fromARGB(255, 47, 235, 225),    // 3-chi bo'lim uchun rang
    const Color.fromARGB(255, 158, 49, 191), // 4-chi bo'lim uchun rang
    Colors.teal, // 4-chi bo'lim uchun rang
    const Color.fromARGB(255, 37, 33, 241),    // 3-chi bo'lim uchun rang
    const Color.fromARGB(255, 220, 247, 82), // 4-chi bo'lim uchun rang
  ];

  List<PieChartSectionData> showingSections() {
    double totalAmount = 0;
    shopData.forEach((shop) {
      totalAmount += double.tryParse(shop['miqdori'] ?? '0') ?? 0;
    });

    return shopData.map((shop) {
      final double amount = double.tryParse(shop['miqdori'] ?? '0') ?? 0;
      final double percentage = (amount / totalAmount) * 100;

      return PieChartSectionData(
        value: percentage,
        color: customColors[shopData.indexOf(shop) % customColors.length], // Rangni o'zgartirish
        title: '${shop['nomi']} \n${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      // PieChart qismini qo'shish
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: showingSections(),
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          children: [
                            TableRow(
                              children: [
                                _headerCell('Xarajat nomi'),
                                _headerCell('Info'),
                                _headerCell('Miqdori'),
                              ],
                            ),
                            ...shopData.map((shop) => TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  children: [
                                    tableCell(shop['nomi'] ?? ''),
                                    tableCell(shop['info'] ?? ''),
                                    tableCell(shop['miqdori'] ?? ''),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPostDialog,
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 238, 207, 244),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Container(
      color: const Color.fromARGB(255, 155, 121, 165),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
