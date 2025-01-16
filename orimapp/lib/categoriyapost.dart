import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _image;
  final picker = ImagePicker();
  final String imgurClientId = '67f9cca8d9fb5a8'; // Imgur Client ID
  String? _uploadedImageUrl;
  final TextEditingController _nameController = TextEditingController();
  final String apiUrl = 'https://dash.vips.uz/api/49/7603/82553';

  List<Map<String, String>> dataList = []; // Ma'lumotlar ro'yxati



//image picker funksion

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadedImageUrl = null; // Reset the uploaded image URL
      } else {
        print('Hech qanday rasm tanlanmadi.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      print('Rasm tanlanmagan!');
      return;
    }

 //rasm yuklash funksiya
    final uri = Uri.parse("https://api.imgur.com/3/image");
    final request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Client-ID $imgurClientId'
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        setState(() {
          _uploadedImageUrl = data['data']['link'];
        });
        print('Rasm yuklandi: $_uploadedImageUrl');
        _postData(_uploadedImageUrl!, _nameController.text);  // API'ga yuborish
      } else {
        print('Xatolik: ${response.statusCode}');
      }
    } catch (e) {
      print('Xatolik: $e');
    }
  }



//api ga post qilish funksiya
  Future<void> _postData(String rasm, String nomi) async {
    final String url = 'https://dash.vips.uz/api-in/49/7603/82553';

    print(rasm);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'rasm': rasm,
          'nomi': nomi,
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

  void _openDetailPage(String rasmUrl, String nomi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(rasmUrl: rasmUrl, nomi: nomi),
      ),
    );
  }




//dizayn qismi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 231, 226, 240), // Modern color theme
        title: Text('categoriya qo`shish', //style: TextStyle(fontWeight: FontWeight.bold)
        ),
       
      ),
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _image == null
                    ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text('Categoriya nomini yozing.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                        ],
                      ),
                    )
                    : Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4))],
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextField(
  controller: _nameController,
  decoration: InputDecoration(
    hintText: 'Nomini kiriting',
    hintStyle: TextStyle(color: Colors.grey),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    // Adding custom focus and enabled borders
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: const Color.fromARGB(255, 219, 123, 249), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    ),
    // Custom prefix icon if needed
   
  ),
),
                SizedBox(height: 20),
                 Row(
                      children: [
                        Text('Rasm tanlang.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                      ],
                    ),
                    SizedBox(height: 10,),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Rasm tanlash', style: TextStyle(fontSize: 16)),
                    ),
                     SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _uploadImage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Rasm yuklash', style: TextStyle(fontSize: 16)),
                ),
                  ],
                ),
           
                SizedBox(height: 20),
              
                SizedBox(height: 20),
                dataList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            child: ListTile(
                              leading: Image.network(dataList[index]['rasm']!, width: 50, height: 50, fit: BoxFit.cover),
                              title: Text(dataList[index]['nomi']!, style: TextStyle(fontWeight: FontWeight.bold)),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  _openDetailPage(dataList[index]['rasm']!, dataList[index]['nomi']!);
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String rasmUrl;
  final String nomi;

  DetailPage({required this.rasmUrl, required this.nomi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ma\'lumotni tahrirlash')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(rasmUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              SizedBox(height: 20),
              Text('Nom: $nomi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Ma'lumotni yangilash funksiyasini qo'shishingiz mumkin
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Yangilash', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
