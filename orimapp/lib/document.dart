import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Date format kutubxonasi

class DocsexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DocsexTable(),
    );
  }
}

class DocsexTable extends StatefulWidget {
  @override
  _DocsexTableState createState() => _DocsexTableState();
}

class _DocsexTableState extends State<DocsexTable> {
  final List<Map<String, String>> shopData = [];
  final String apiUrl = "https://dash.vips.uz/api/49/7603/82587";
   int dialogCount = 0; // Bosilgan marta sonini saqlash


  

  Future<void> fetchShopData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          shopData.clear();
          shopData.addAll(data.map((item) {
            return {
              'id': item['id'].toString(),
              'mahsulotid': item['mahsulotid'].toString(),
              'kelgannarx': item['kelgannarx'].toString(),
              'miqdori': item['miqdori'].toString(),
              'sana': item['sana'].toString(),
              'yetkazibberuvchiid': item['yetkazibberuvchiid'].toString(),
               'jaminarxi': item['jaminarxi'].toString(),
              
            };
          }).toList());
        });
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
//update function for design
  void _showEditDialog(Map<String, String> shop) {
    TextEditingController kelgannarxController = TextEditingController(text: shop['kelgannarx']);
    TextEditingController miqdoriController = TextEditingController(text: shop['miqdori']);
    TextEditingController sanaController = TextEditingController(text: shop['sana']);
    TextEditingController yetkazibberuvchiidController = TextEditingController(text: shop['yetkazibberuvchiid']);
     TextEditingController mahsulotidController = TextEditingController(text: shop['mahsulotid']);
         TextEditingController jaminarxiController = TextEditingController(text: shop['miqdori']);

         // jami narx hisoblash funksiyasi
double jamiNarxniHisobla(double miqdori, double kelganNarx) {
  return miqdori * kelganNarx;
}

// tugma bosilganda ishlatiladigan yangilangan funksiya
void narxniYangilash() {
  // miqdori va kelgan narx qiymatlarini olish va ularni double ga aylantirish
  double miqdori = double.tryParse(miqdoriController.text) ?? 0.0;
  double kelganNarx = double.tryParse(kelgannarxController.text) ?? 0.0;

  // agar qiymatlar noto'g'ri yoki bo'sh bo'lsa, xato xabarini ko'rsatish
  if (miqdori == 0.0 || kelganNarx == 0.0) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iltimos, to'g'ri qiymat kiriting.")));
    return;
  }

  // jami narxni hisoblash
  double jamiNarx = jamiNarxniHisobla(miqdori, kelganNarx);

  // jaminarxiController.text ni yangilash
  jaminarxiController.text = jamiNarx.toStringAsFixed(2);

  // Agar jaminarxiController.text o'zgarishini ko'rsatish kerak bo'lsa, setState ishlatish mumkin
  setState(() {
    // Bu yerda kerakli UI yangilanishini amalga oshirishingiz mumkin
  });
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ma'lumotni tahrirlash"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            
              TextField(
                controller: kelgannarxController, 
                decoration: InputDecoration(
                  labelText: 'Kelgan Narx')),
              TextField(
                controller: miqdoriController,
                 decoration: InputDecoration(
                  labelText: 'Miqdori')),
                  TextField(
                    controller: jaminarxiController,
                    decoration: InputDecoration(
                      labelText: 'jami narxi',
                      suffix: IconButton(
                        icon: Icon(Icons.calculate,color: Colors.amber,),
                        onPressed: (){narxniYangilash();
                          
                        },)
                    ),
                  ),

              TextField(
                controller: sanaController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Sana',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),color: const Color.fromARGB(255, 169, 80, 214),
                    onPressed: _selectDate,
                  ),
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Text("O`chirish uchun bu yerni bosing"),
                      //  IconButton(icon: Icon(Icons.delete), onPressed: () => del(product.id)),
                    ],
                  ),
                ),
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Bekor qilish")),
            TextButton(
              onPressed: () {
                // Call the update function here when save is pressed
                upData(
                  shop['id']!, // Use the 'id' from the shop
                  mahsulotidController.text,
                   yetkazibberuvchiidController.text,
                  kelgannarxController.text,
                  miqdoriController.text,
                  jaminarxiController.text,
                  sanaController.text,
                 
                );
                Navigator.pop(context); // Close the dialog after saving
              },
              child: Text("Saqlash"),
            ),
          ],
        );
      },
    );
  }

  // Update function
  Future<void> upData(
    String id,
    String mahsulotid,
     String yetkazibberuvchiid,
    String kelgannarx,
    String miqdori,
    String jaminarxi,
    String sana,
   
  ) async {
    final String url = 'https://dash.vips.uz/api-up/49/7603/82587';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'mahsulotid': mahsulotid,
          'yetkazibberuvchiid': yetkazibberuvchiid,
          'kelgannarx': kelgannarx,
          'miqdori': miqdori,
          'jaminarxi':jaminarxi,
          'sana': sana,
         
          'where': "id:$id",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully!')),
        );
        fetchShopData(); // Refresh product list after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update product')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error occurred')),
      );
    }
  }

//post qilish malumot jonatish apiga 
    Future<void> postData(
      String mahsulotid,
     String yetkazibberuvchiid,
       String kelgannarx,
       String miqdori,
       String jaminarxi,
       String sana,
)
        
         async {
    final String url = 'https://dash.vips.uz/api-in/49/7603/82587';

    try {
       final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body:{
          'apipassword': '6370',
          'mahsulotid': mahsulotid,
           'yetkazibberuvchiid':yetkazibberuvchiid,
          'kelgannarx': kelgannarx,
          'miqdori':miqdori,
          'jaminarxi':jaminarxi,
          'sana':sana,
       
           

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





void _showAddDialog() {
  TextEditingController kelgannarxController = TextEditingController();
  TextEditingController miqdoriController = TextEditingController();
   TextEditingController jaminarxiController = TextEditingController();
  TextEditingController sanaController = TextEditingController();

  // jami narx hisoblash funksiyasi
double jamiNarxniHisobla(double miqdori, double kelganNarx) {
  return miqdori * kelganNarx;
}

// tugma bosilganda ishlatiladigan funksiya
void jamiNarxniHisoblash() {
  // miqdori va kelgan narx qiymatlarini olish va ularni double ga aylantirish
  double miqdori = double.tryParse(miqdoriController.text) ?? 0.0;
  double kelganNarx = double.tryParse(kelgannarxController.text) ?? 0.0;

  // agar qiymatlar noto'g'ri yoki bo'sh bo'lsa, xato xabarini ko'rsatish
  if (miqdori == 0.0 || kelganNarx == 0.0) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iltimos, to'g'ri qiymat kiriting.")));
    return;
  }

  // jami narxni hisoblash
  double jamiNarx = jamiNarxniHisobla(miqdori, kelganNarx);

  // jaminarxiController.text ni yangilash
  jaminarxiController.text = jamiNarx.toStringAsFixed(2);

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
  Future<void> fetchYetkazibBeruvchiIds() async {
    final String url = 'https://dash.vips.uz/api/49/7603/82563'; // API URL for suppliers
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
  fetchYetkazibBeruvchiIds();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Mahsulot qo'shish"),
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
                    future: fetchYetkazibBeruvchiIds(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error fetching supplier IDs');
                      } else {
                        return DropdownButtonFormField<String>(
                          value: selectedYetkazibBeruvchiId,
                          hint: Text("Yetkazib beruvchi ID tanlang"),
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
                    decoration: InputDecoration(labelText: 'Kelgan Narx'),
                  ),
                  // Miqdori
                  TextField(
                    controller: miqdoriController,
                    decoration: InputDecoration(labelText: 'Miqdori'),
                  ),
                  //jaminarxi
                  TextField(
                    controller: jaminarxiController,
                    decoration: InputDecoration(
                     labelText: 'jami narxi' ,
                     
                     
                     suffixIcon: IconButton(
                      icon: Icon(Icons.calculate,color: Colors.amber,),
                      onPressed:() => jamiNarxniHisoblash()
                       )
                    ),
                     readOnly: true,
                  ),
                  // Sana
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
                  if (selectedMahsulotId != null && selectedYetkazibBeruvchiId != null) {
                    await postData(
                      selectedMahsulotId!,
                     selectedYetkazibBeruvchiId!,
                      kelgannarxController.text,
                      miqdoriController.text,
                       jaminarxiController.text,
                      sanaController.text,
                    
                     
                    );
                    Navigator.pop(context);
                    fetchShopData(); // Yangi mahsulot qo'shilgandan keyin ma'lumotlarni yangilash
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Iltimos, barcha maydonlarni to\'ldiring')),
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






  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 253, 254),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 252, 252),
          actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ma’lumot yangilanmoqda...')),
              );
              fetchShopData();
            },
          ),
        ],
        title: Text('Omborim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                      children: [
                        for (var header in ['Mahsulot ID', 'Yetkazib Beruvchi ID', 'Kelgan Narx', 'Miqdori','jaminarxi', 'Sana',])
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(header, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),

                          
                      ],
                    ),
                    ...shopData.map((shop) {
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        children: [
                          for (var key in ['mahsulotid', 'yetkazibberuvchiid', 'kelgannarx', 'miqdori','jaminarxi', 'sana',])
                            GestureDetector(
                              onTap: () => _showEditDialog(shop),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(shop[key]!),
                              ),
                            ),
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
  onPressed: _showAddDialog,
  child: Icon(Icons.add),
),

     
    );
  }
}


