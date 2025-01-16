import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class MijozPage extends StatefulWidget {
  const MijozPage({super.key});

  @override
  State<MijozPage> createState() => _MijozPageState();
}

class _MijozPageState extends State<MijozPage> {
  final List<Map<String, String>> shopData = [];
  bool isLoading = false;

  Future<void> fetchShopData() async {
    setState(() => isLoading = true);
    const String apiUrl = "https://dash.vips.uz/api/49/7603/82586";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          shopData.clear();
          shopData.addAll(data.map((item) => {
                'id': item['id'].toString(),
                'mijozismi': item['mijozismi'].toString(),
                'telifonraqami': item['telifonraqami'].toString(),
                'manzili': item['manzili'].toString(),
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
  Future<void> postData(String mijozismi,String telifonraqami, String manzili,) async {
    if (mijozismi.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, malumotlarni kiriting!"), backgroundColor: Colors.red),
      );
      return;
    }

    final String url = 'https://dash.vips.uz/api-in/49/7603/82586';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'mijozismi':mijozismi , 
          'telifonraqami': telifonraqami,
          'manzili': manzili,
        
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
   
     final TextEditingController mijozismiController = TextEditingController();
      final TextEditingController telifonraqamiController = TextEditingController();
       final TextEditingController manziliController = TextEditingController();
     
  
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mijozlar paneli'),
          content: Column(
             mainAxisSize: MainAxisSize.min,
            children: [
             TextField(
              controller: mijozismiController,
              decoration: InputDecoration(
                labelText: 'mijoz ismi',

              ),

             ),
             TextField(
              controller: telifonraqamiController,
              decoration: InputDecoration(
                labelText: 'telifon raqami',

              ),
             ),
              TextField(
              controller: manziliController,
              decoration: InputDecoration(
                labelText: 'manzilini kiriting',

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
                mijozismiController.text.trim(),
                telifonraqamiController.text.trim(),
                manziliController.text.trim(),

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
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black,
        ),
      ),
    );
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
                          tableCell('ID', isHeader: true),
                          tableCell('Mijoz ismi', isHeader: true),
                          tableCell('Telefon raqami', isHeader: true),
                          tableCell('Manzili', isHeader: true),
                        ],
                      ),
                      ...shopData.map((shop) {
                        return TableRow(
                          children: [
                             tableCell(shop['id'] ?? ''),
                            tableCell(shop['mijozismi'] ?? ''),
                            tableCell(shop['telifonraqami'] ?? ''),
                            tableCell(shop['manzili'] ?? ''),
                          ],
                        );
                      }).toList(),
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
}
