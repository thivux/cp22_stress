import 'package:flutter/material.dart';
import 'nsdr.dart';
import 'py_sigh.dart';
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
            title: const Text('Stress reduce method'),
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: const TabBarView(
            children: [
              Bubble(),
              NSDR(),
            ],
          ),
        ),
      ),
    );
  }
}
