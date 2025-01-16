import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController modelController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  String? _uploadedImageUrl;
  final String imgurClientId = '67f9cca8d9fb5a8';
  bool _isUploading = false;
  String? selectedCategoryId;
  List<String> categoryIds = [];

  // Tasodifiy 6 xonali barcode yaratish
  String _generateRandomBarcode() {
    return (Random().nextInt(900000) + 100000).toString();
  }

  // Galereyadan rasm tanlash
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _uploadedImageUrl = null;
      });
    }
  }

  // Rasmni Imgurga yuklash
  Future<void> _uploadImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Iltimos, rasm tanlang!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final uri = Uri.parse("https://api.imgur.com/3/image");
    final request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Client-ID $imgurClientId'
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _uploadedImageUrl = data['data']['link'];
          _isUploading = false;
        });
        print('Rasm yuklandi: $_uploadedImageUrl');
      } else {
        throw Exception('Rasm yuklashda xatolik: ${data['data']['error']}');
      }
    } catch (e) {
      print('Xatolik: $e');
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rasm yuklanmadi: $e')),
      );
    }
  }

  // Ma'lumotlarni yuborish
  Future<void> postData(String categoriyaid, String rasm, String model, String barcode) async {
    final String url = 'https://dash.vips.uz/api-in/49/7603/82554';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'apipassword': '6370',
          'categoriyaid': categoriyaid,
          'rasm': rasm,
          'model': model,
          'barcode': barcode,
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

  // Fetch category data from API
  Future<void> _fetchCategoryData() async {
    final String url = 'https://dash.vips.uz/api/49/7603/82553';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          categoryIds = data.map((category) => category['id'].toString()).toList();
        });
      } else {
        throw Exception('Kategoriya ma’lumotlari yuklanmadi');
      }
    } catch (e) {
      print('Xatolik: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriya ma’lumotlari yuklanmadi: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategoryData(); // Fetch category data on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Tovar kiritish",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCategoryDropdown(),
              SizedBox(height: 16),
              _buildTextField(modelController, "Model"),
              SizedBox(height: 16),
              _buildBarcodeTextField(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Rasm kiritish", style: TextStyle(fontSize: 16)),
              ),
              if (_image != null) ...[
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, fit: BoxFit.cover, height: 200),
                ),
              ],
              SizedBox(height: 20),
              _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadImage,
                      child: Text("Rasmni Yuklash", style: TextStyle(fontSize: 16)),
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_uploadedImageUrl != null) ? () {
                  postData(
                    selectedCategoryId ?? '',
                    _uploadedImageUrl!,
                    modelController.text,
                    barcodeController.text,
                  );
                } : null,
                child: Text("Saqlash", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButton<String>(
      value: selectedCategoryId,
      hint: Text("Kategoriya tanlang"),
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() {
          selectedCategoryId = newValue;
        });
      },
      items: categoryIds.map((String id) {
        return DropdownMenuItem<String>(
          value: id,
          child: Text(id),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 219, 123, 249), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildBarcodeTextField() {
    return TextField(
      controller: barcodeController,
      decoration: InputDecoration(
        labelText: "Barcode",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 219, 123, 249), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: () {
            setState(() {
              barcodeController.text = _generateRandomBarcode();
            });
          },
        ),
      ),
    );
  }
}
