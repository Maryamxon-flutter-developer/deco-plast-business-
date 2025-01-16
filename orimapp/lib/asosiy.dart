import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:orimapp/addproduct.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List products = [];
  final String apiUrl = "https://dash.vips.uz/api/49/7603/82554";
  final String apiPassword = "6370";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts({String? categoriyaid}) async {
    String url = categoriyaid != null ? "$apiUrl?categoriyaid=$categoriyaid" : apiUrl;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Apipassword": apiPassword,
      });

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
        });
      } else {
        showMessage("Xatolik: ${response.statusCode}");
      }
    } catch (e) {
      showMessage("Tarmoq xatosi yuz berdi");
    }
  }

  Future<void> del(String id) async {
    final String url = 'https://dash.vips.uz/api-del/49/7603/82554?id=$id';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'apipassword': apiPassword,
        'where': "id:$id",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage('Ma`lumot o‘chirildi');
        fetchProducts();
      } else {
        showMessage('Xatolik: ${response.statusCode}');
      }
    } catch (e) {
      showMessage('Tarmoq xatosi yuz berdi');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void showEditDialog(Map<String, dynamic> item) {
    TextEditingController nameController = TextEditingController(text: item["model"]);
   // TextEditingController infoController = TextEditingController(text: item["categoriyaid"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ma'lumotlarni o'zgartirish"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "model")),
             // TextField(controller: infoController, decoration: InputDecoration(labelText: "Ma'lumoti")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Bekor qilish")),
            TextButton(
              onPressed: () {
                upData(item["id"], nameController.text, );
                Navigator.pop(context);
              },
              child: Text("Saqlash"),
            ),
          ],
        );
      },
    );
  }

  Future<void> upData(String id, String model, ) async {
    final String url = 'https://dash.vips.uz/api-up/49/7603/82554';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'apipassword': apiPassword,
        'model': model,
        
        'where': "id:$id",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage('Ma’lumot yangilandi!');
        fetchProducts();
      } else {
        showMessage('Yangilash amalga oshmadi');
      }
    } catch (e) {
      showMessage('Tarmoq xatosi yuz berdi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tovarlar"),
       actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ma’lumot yangilanmoqda...')),
              );
              fetchProducts();
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),

      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(product['rasm']), fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                             Text("mahsulot ID: ${product['id']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Model: ${product['model']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Kategoriya: ${product['categoriyaid']}", style: TextStyle(fontWeight: FontWeight.bold)),
                            
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              width: 90,
                              height: 40,
                              color: const Color.fromARGB(255, 224, 135, 246),
                              child: Center(
                                child: Text("Barcode: ${product['barcode']}", style: TextStyle(fontWeight: FontWeight.bold)), 
                              ),
                            ),
                          ),
                          IconButton(icon: Icon(Icons.edit), onPressed: () => showEditDialog(product)),
                          IconButton(icon: Icon(Icons.delete), onPressed: () => del(product['id'])),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage()));
          if (result == true) fetchProducts();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
