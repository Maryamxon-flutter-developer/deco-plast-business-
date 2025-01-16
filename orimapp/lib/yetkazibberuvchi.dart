import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  // Fetch Data from API
  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse("https://dash.vips.uz/api/49/7603/82563"));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = jsonDecode(response.body);
        setState(() {
          data = fetchedData.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        throw Exception("Data not found");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Post Data to API
  Future<void> postData(String firmanomi) async {
    if (firmanomi.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, yetkazib beruvchi nomini kiriting!"), backgroundColor: Colors.red),
      );
      return;
    }

    final String url = 'https://dash.vips.uz/api-in/49/7603/82563';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'firmanomi': firmanomi, // Faqat firmanomi yuboriladi
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ma’lumot muvaffaqiyatli qo‘shildi!')),
        );
        fetchData(); // Ma’lumotlarni qayta yuklash
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
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yetkazib beruvchi qo‘shish'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Yetkazib beruvchi nomini kiriting',
              labelStyle: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: Icon(Icons.business, color: Colors.purple),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.deepPurple, width: 3),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                postData(nameController.text.trim());
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
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Yetkazib beruvchilar'),
        backgroundColor: const Color.fromARGB(255, 246, 244, 249),
          actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ma’lumot yangilanmoqda...')),
              );
              fetchData();
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 253, 253, 252),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: screenWidth,
                ),
                child: Table(
                  border: TableBorder.all(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey,
                    width: 1,
                  ),
                  columnWidths: _getColumnWidths(screenWidth),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 155, 121, 165),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                      ),
                      children: [
                        headerCell('ID'),
                        headerCell('YETKAZIB BERUVCHI'),
                      ],
                    ),
                    ...data.map((item) {
                      return TableRow(
                        children: [
                          tableCell(item['id'].toString()), // ID ko'rsatish
                          tableCell(item['firmanomi'] ?? 'N/A'),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPostDialog,
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 238, 207, 244),
      ),
    );
  }

  Widget headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Map<int, TableColumnWidth> _getColumnWidths(double screenWidth) {
    return {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(2),
    };
  }
}
