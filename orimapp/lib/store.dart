import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<Map<String, dynamic>> cart = []; // To hold selected products in the cart

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('https://dash.vips.uz/api/49/7603/82554'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data;
        filteredProducts = data;
      });
    }
  }

///filter 
  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        String model = product['model'].toString().toLowerCase();
        String id = product['id'].toString();
        return model.contains(query.toLowerCase()) || id.contains(query);
      }).toList();
    });
  }

 
//////////apiga malumot jo`natish
  Future<void> postData(String mahsulotid, String mijozid,String savdonarx, String savdomiqdori, String sana, String itago) async {
    final String url = 'https://dash.vips.uz/api-in/49/7603/82561';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'mahsulotid': mahsulotid,
           'mijozid': mijozid,
          'savdonarx': savdonarx,
          'savdomiqdori': savdomiqdori,
          'sana': sana,
           'itago': itago,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Response: $data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data posted successfully!')),
        );
      } else {
        print('Failed to post data: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post data')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }
///dizayn 
  void _showAddDialog(String productId) {
    TextEditingController kelgannarxController = TextEditingController();
    TextEditingController miqdoriController = TextEditingController();
    TextEditingController sanaController = TextEditingController();
      TextEditingController itagoController = TextEditingController();

      Future<void> fetchProductDetails(String productId) async {
  final response = await http.get(Uri.parse('https://dash.vips.uz/api/49/7603/82587'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    var product = data.firstWhere((item) => item['mahsulotid'].toString() == productId, orElse: () => null);
    if (product != null) {
      setState(() {
        _showAddDialog(productId); // Produkt topilgandan keyin dialogni ochish
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mahsulot topilmadi!")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Mahsulot ma'lumotlarini olishda xatolik yuz berdi!")),
    );
  }
}
      // jami narx hisoblash funksiyasi
double jamiNarxniHisobla(double savdomiqdori, double savdonarx) {
  return savdomiqdori * savdonarx;
}

// tugma bosilganda ishlatiladigan yangilangan funksiya
void narxniYangilash() {
  // miqdori va kelgan narx qiymatlarini olish va ularni double ga aylantirish
  double savdomiqdori = double.tryParse(miqdoriController.text) ?? 0.0;
  double savdonarx = double.tryParse(kelgannarxController.text) ?? 0.0;

  // agar qiymatlar noto'g'ri yoki bo'sh bo'lsa, xato xabarini ko'rsatish
  if (savdomiqdori == 0.0 || savdonarx == 0.0) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iltimos, to'g'ri qiymat kiriting.")));
    return;
  }

  // jami narxni hisoblash
  double jamiNarx = jamiNarxniHisobla(savdomiqdori, savdonarx);

  // jaminarxiController.text ni yangilash
  itagoController.text = jamiNarx.toStringAsFixed(2);

  // Agar jaminarxiController.text o'zgarishini ko'rsatish kerak bo'lsa, setState ishlatish mumkin
  setState(() {
    // Bu yerda kerakli UI yangilanishini amalga oshirishingiz mumkin
  });
}






    String? selectedMahsulotId;
    String? selectedYetkazibBeruvchiId;

    List<String> mahsulotIds = [];
    List<String> yetkazibBeruvchiIds = [];

    // Fetching Product IDs
    Future<void> fetchMahsulotIds() async {
      final String url = 'https://dash.vips.uz/api/49/7603/82554'; // API URL for products
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            mahsulotIds = data.map((item) => item['id'].toString()).toList();
          });
        } else {
          throw Exception('Failed to load product IDs');
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching product IDs')),
        );
      }
    }

    // Fetching Supplier IDs
    Future<void> fetchmijozid() async {
      final String url = 'https://dash.vips.uz/api/49/7603/82586'; // API URL for suppliers
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            yetkazibBeruvchiIds = data.map((item) => item['id'].toString()).toList();
          });
        } else {
          throw Exception('Failed to load supplier IDs');
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching supplier IDs')),
        );
      }
    }

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

    // Fetch the data before showing the dialog
    fetchMahsulotIds();
    fetchmijozid();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Savdo"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Using FutureBuilder for Product Dropdown
                    FutureBuilder(
                      future: fetchMahsulotIds(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error fetching product IDs');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: selectedMahsulotId,
                            hint: Text("Mahsulot ID tanlang"),
                            items: mahsulotIds.map((id) {
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMahsulotId = value;
                              });
                            },
                          );
                        }
                      },
                    ),
                    // Using FutureBuilder for Supplier Dropdown
                    FutureBuilder(
                      future: fetchmijozid(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error fetching supplier IDs');
                        } else {
                          return DropdownButtonFormField<String>(
                            value: selectedYetkazibBeruvchiId,
                            hint: Text("Mijoz ID tanlang"),
                            items: yetkazibBeruvchiIds.map((id) {
                              return DropdownMenuItem<String>(
                                value: id,
                                child: Text(id),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedYetkazibBeruvchiId = value;
                              });
                            },
                          );
                        }
                      },
                    ),
                    // Kelgan Narx
                    TextField(
                      controller: kelgannarxController,
                      decoration: InputDecoration(labelText: 'savdo narx'),
                    ),
                    // Miqdori
                    TextField(
                      controller: miqdoriController,
                      decoration: InputDecoration(labelText: 'mahsulot miqdori'),
                    ),
                    // Sana
                    TextField(
                      controller: sanaController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Sana',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today,color: const Color.fromARGB(179, 201, 43, 240),),
                          onPressed: _selectDate,
                        ),
                      ),
                    ),
                    TextField(
                      controller: itagoController,
                      decoration: InputDecoration(
                         labelText: 'jami hisob',
                         suffix: IconButton(
                          icon: Icon(Icons.calculate,color: Colors.amber,),
                          onPressed: () =>narxniYangilash())

                      ),
                    )
                  ],
                ),
              ),
              actions: [
                // Bekor qilish
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Bekor qilish"),
                ),
                // Saqlash
                TextButton(
                  onPressed: () async {
                 if (selectedMahsulotId != null &&
                  kelgannarxController.text.isNotEmpty &&
                   miqdoriController.text.isNotEmpty && 
                   sanaController.text.isNotEmpty && 
                   itagoController.text.isNotEmpty ) {


                      await postData(
                        selectedMahsulotId!,
                        selectedYetkazibBeruvchiId!,
                        kelgannarxController.text,
                        miqdoriController.text,
                        sanaController.text,
                        itagoController.text,

                        
                      );
                      Navigator.pop(context);
                      fetchProducts(); // Yangi mahsulot qo'shilgandan keyin ma'lumotlarni yangilash
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Tanlangan barcha maydonlarni to'ldiring")),
                      );
                    }
                  },
                  child: Text("Saqlash"),
                ),
              ],
            );
          },
        );
      },
    );
  }
/////////body qismi
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingSize = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(title: Text("Savdo bo`limi"),
      backgroundColor: const Color.fromARGB(255, 254, 254, 253),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 254),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: searchController,
              onChanged: filterProducts,
              decoration: InputDecoration(
                hintText: "Model yoki ID bilan qidiring",
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    // Adding custom focus and enabled borders
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: const Color.fromARGB(255, 216, 147, 239), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
       borderSide: BorderSide(color: Color.fromARGB(255, 144, 143, 144), width: 1),
    ),
              ),
            ),
          ),
          // Product list
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Set the number of columns based on screen width
                      int crossAxisCount = 1;
                      if (constraints.maxWidth > 800) {
                        crossAxisCount = 3; // For large screens like tablets and desktops
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 2; // For medium screens like tablets
                      }

                      return GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: paddingSize),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 2,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          var product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () => _showAddDialog(product['id'].toString()),
                            child: Card(
                               color:  const Color.fromARGB(255, 233, 228, 235),
                              elevation: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 170,
                                          height: 150,
                                          child: Image.network(
                                            product['rasm'],
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Model : ${product['model']}',
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                Text("Mahsulot ID: ${product['id']}"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                   // Cart summary
        
      
    
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          
        
        ],
      ),

      
      
    );
    
  }
  
} 

























