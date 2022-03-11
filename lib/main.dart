import 'package:flutter/material.dart';
import 'nsdr.dart';
import 'bubble.dart';

void main() => runApp(const FirstPageApp());

class FirstPageApp extends StatelessWidget {
  const FirstPageApp({Key? key}) : super(key: key);
  static List<Tab> myTabs = <Tab>[
    Tab(
        icon: Image.asset(
          'assets/breathing.png',
          height: 32,
          width: 32,
        )),
    Tab(
        icon: Image.asset(
          'assets/listening.png',
          height: 32,
          width: 32,
        )),
    // Tab(icon: Image.asset('assets/Numbers_4_icon.png')),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Giảm áp lực tức thì'),
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: const TabBarView(
            children: [
              Bubble(),
              NSDR(),
              // Text('Tab three'),
            ],
          ),
        ),
      ),
    );
  }
}

