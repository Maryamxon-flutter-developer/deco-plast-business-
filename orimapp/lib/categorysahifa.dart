import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For File handling
import 'package:image_picker/image_picker.dart';
import 'package:orimapp/asosiy.dart';
import 'package:orimapp/categoriyapost.dart'; // Image picker package

class Categoriya extends StatefulWidget {
  const Categoriya({super.key});

  @override
  State<Categoriya> createState() => _CategoriyaState();
}

class _CategoriyaState extends State<Categoriya> {
  late Future<List<Category>> categories;

  @override
  void initState() {
    super.initState();
    categories = fetchCategories();
  }

  // API data fetching function
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://dash.vips.uz/api/49/7603/82553'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Delete function
  Future<void> del(String id) async {
    final String url = 'https://dash.vips.uz/api-del/49/7603/82553?id=$id';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'where': "id:$id",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Response: $responseData');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ma`lumot ochirildi')),
        );

        // Refresh the categories list after deletion
        setState(() {
          categories = fetchCategories();
        });
      } else {
        // Show error message with the status code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xatolik: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');

      // Show network error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarmoq xatosi yuz berdi')),
      );
    }
  }

  // Delete confirmation dialog
  void showIdDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bu elementni o`chirasizmi?"),
          content: Text("Ushbu elementning ID si: $id"),
          actions: [
            TextButton(
              onPressed: () {
                del(id);
                Navigator.of(context).pop();
              },
              child: Text(
                "o`chirish",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("bekor qilish"),
            ),
          ],
        );
      },
    );
  }

  // Image picker functionality
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Update function
  Future<void> upData(String id, String nomi, String rasm) async {
    final String url = 'https://dash.vips.uz/api-up/49/7603/82553';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          
          'nomi': nomi,
          'rasm': rasm, // Updated image URL
          'where': "id:$id",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully!')),
        );
        fetchCategories(); // Refresh product list after update
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

  // Edit Dialog
  void showEditDialog(Map<String, dynamic> item) {
    TextEditingController nameController = TextEditingController(text: item["nomi"]);
    TextEditingController infoController = TextEditingController(text: item["rasm"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Ma'lumotlarni o'zgartirish"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nomi"),
                ),
                TextField(
                  controller: infoController,
                  decoration: InputDecoration(labelText: "Ma'lumoti"),
                ),
                SizedBox(height: 20),
                _imageFile == null
                    ? Text('No image selected.')
                    : Image.file(_imageFile!),  // Display selected image
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,  // Trigger image picker
                  child: Text('Choose Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Bekor qilish"),
            ),
            TextButton(
              onPressed: () {
                // Upload the updated data with the new image
                if (_imageFile != null) {
                  // Replace with actual logic to upload the image and get its URL
                  String imageUrl = "new_image_url_here";  // Example placeholder URL

                  upData(
                    item["id"],
                    nameController.text,
                    imageUrl,  // Updated image URL
                  );
                } else {
                  upData(
                    item["id"],
                    nameController.text,
                    infoController.text,  // Use existing info if no image selected
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text("Saqlash"),
            ),
          ],
        );
      },
    );
  }

  // Body of the Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 254, 252, 255),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color.fromARGB(255, 243, 244, 250),
            
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Tovar categoriyasi',style: TextStyle(fontWeight: FontWeight.w400,fontStyle: FontStyle.italic),),
            background: Image.asset("assets/ide.jpg",fit: BoxFit.cover,),
            
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FutureBuilder<List<Category>>(
                  future: categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available.'));
                    } else {
                      List<Category> categories = snapshot.data!;

                      return Column(
                        children: categories.map((category) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the category detail page
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductPage()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                width: 260,  // Kenglikni o'zgartirmadik
                                decoration: BoxDecoration(
                                  color:  const Color.fromARGB(255, 233, 228, 235),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min, // Minimal bo‘lishini ta'minlash
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            category.rasm,
                                            width: double.infinity,
                                            height: 140,  // Balandlikni qisqartirdik
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            width: 45,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(193, 255, 255, 255),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                showIdDialog(category.id);
                                              },
                                              icon: Icon(Icons.delete),
                                              color: const Color.fromARGB(255, 68, 9, 95),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 60,
                                          child: Container(
                                            width: 45,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(188, 255, 255, 255),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                showEditDialog({
                                                  "id": category.id,
                                                  "nomi": category.nomi,
                                                  "rasm": category.rasm,
                                                });
                                              },
                                              icon: Icon(Icons.edit),
                                              color: const Color.fromARGB(255, 62, 4, 80),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    category.nomi,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                               SizedBox(width: 10,),
                                          Container(
                                            width: 150,
                                            height: 40,
                                            color: const Color.fromARGB(255, 209, 112, 239),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'categoriya:',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                 Text(
                                              category.id,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                              ],
                                            ),
                                          ),
                                         
                                            ],
                                          ),
                                         
                                        ],
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 229, 199, 244),
      ),
    );
  }
}

class Category {
  final String id;
  final String nomi;
  final String rasm;

  Category({required this.id, required this.nomi, required this.rasm});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      nomi: json['nomi'],
      rasm: json['rasm'],
    );
  }
}
