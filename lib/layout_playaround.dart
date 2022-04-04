import 'package:flutter/material.dart';

void main() {
  return runApp(MaterialApp(home: Layout()));
}

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Colors.green,
              padding: EdgeInsets.all(32.0),
            ),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(32.0),
            ),
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(32.0),
            ),
          ],
        ),
      ),
    );
  }
}
