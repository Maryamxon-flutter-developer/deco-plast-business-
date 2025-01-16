import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class QarzlarPage extends StatefulWidget {
  const QarzlarPage({super.key});

  @override
  State<QarzlarPage> createState() => _QarzlarPageState();
}

class _QarzlarPageState extends State<QarzlarPage> {
  final List<Map<String, String>> shopData = [];
  bool isLoading = false;

  Future<void> fetchShopData() async {
    setState(() => isLoading = true);
    const String apiUrl = "https://dash.vips.uz/api/49/7603/82559";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          shopData.clear();
          shopData.addAll(data.map((item) => {
                'firma': item['firma'].toString(),
                'miqdori': item['miqdori'].toString(),
                'sana': item['sana'].toString(),
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
  Future<void> postData(String firma,String miqdori,String sana, ) async {
    if (firma.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, yetkazib beruvchi nomini kiriting!"), backgroundColor: Colors.red),
      );
      return;
    }

    final String url = 'https://dash.vips.uz/api-in/49/7603/82559';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'firma': firma, // Faqat firmanomi yuboriladi
          'miqdori': miqdori,
          'sana': sana,
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
   
     final TextEditingController firmaController = TextEditingController();
      final TextEditingController miqdoriController = TextEditingController();
       final TextEditingController sanaController = TextEditingController();
            Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        sanaController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Qarzdorliklar'),
          content: Column(
             mainAxisSize: MainAxisSize.min,
            children: [
             TextField(
              controller: firmaController,
              decoration: InputDecoration(
                labelText: 'qarzdorlik',

              ),

             ),
             TextField(
              controller: miqdoriController,
              decoration: InputDecoration(
                labelText: 'miqdori',

              ),
             ),
               TextField(
                    controller: sanaController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Sana',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today,color: const Color.fromARGB(255, 200, 15, 252),),
                        onPressed: _selectDate,
                      ),
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
                firmaController.text.trim(),
                miqdoriController.text.trim(),
                sanaController.text.trim(),

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
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.grey,
                      width: 1,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 155, 121, 165),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        children: [
                          tableCell('Firma', isHeader: true),
                          tableCell('Miqdori', isHeader: true),
                          tableCell('Sana', isHeader: true),
                        ],
                      ),
                      ...shopData.map((shop) => TableRow(
                            children: [
                              tableCell(shop['firma'] ?? ''),
                              tableCell(shop['miqdori'] ?? ''),
                              tableCell(shop['sana'] ?? ''),
                            ],
                          )),
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

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          color: isHeader ? Colors.white : Colors.black,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
