import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';

import 'package:orimapp/mijoz.dart';
import 'package:orimapp/personpage.dart';
import 'package:orimapp/qarzdorlar.dart';
import 'package:orimapp/qarzpage.dart';
import 'package:orimapp/xarajat.dart';

class QarzPage extends StatefulWidget {
  @override
  _QarzPageState createState() => _QarzPageState();
}

class _QarzPageState extends State<QarzPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor:  const Color.fromARGB(255, 218, 180, 236),
        title: Text('Shaxsiy kabinet'),
        leading: IconButton(
          onPressed: () {
          Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
         actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton.outlined(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PersonPage(),));
          }, icon: Icon(Icons.person)),
        ),]
      ),
      backgroundColor: const Color.fromARGB(255, 220, 181, 238),
      body: Column(
        children: [
          SizedBox(height: 50), // AppBar balandligi uchun
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClayContainer(
              color:  const Color.fromARGB(255, 202, 168, 230),
              borderRadius: 15,
              depth: 20,
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 199, 140, 218),
                  borderRadius: BorderRadius.circular(15),
                ),
                labelColor: const Color.fromARGB(255, 245, 242, 242),
                unselectedLabelColor: const Color.fromARGB(255, 82, 81, 81),
                tabs: [
                  Tab(text: 'Qarzlar'),
                  Tab(text: 'Qarzdor'),
                  Tab(text: 'Mijozlar'),
                  Tab(text: 'Xarajat'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                QarzlarPage(),
                QarzdorlarPage(),
                MijozPage(),
                XarajatlarPage(),
                // Add the widget for the 4th tab 'Xarajat' here
                // Replace with the correct widget for 'Xarajat' page
           
              ],
            ),
          ),
        ],
      ),
    );
  }
}
