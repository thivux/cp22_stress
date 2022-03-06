import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Bubble(),
  ));
}

class Bubble extends StatefulWidget {
  @override
  BubbleState createState() {
    return BubbleState();
  }
}

class BubbleState extends State<Bubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _marginAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));

    _marginAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
          // inhale 1
          tween: Tween<double>(begin: 100, end: 40),
          weight: 1.5),
      TweenSequenceItem(
          // stop
          tween: Tween<double>(begin: 40, end: 40),
          weight: 1),
      TweenSequenceItem(
          // inhale 2
          tween: Tween<double>(begin: 40, end: 30),
          weight: 1),
      TweenSequenceItem(
          // stop
          tween: Tween<double>(begin: 30, end: 30),
          weight: 1),
      TweenSequenceItem(
          // exhale
          tween: Tween<double>(begin: 30, end: 100),
          weight: 7),
      TweenSequenceItem(
          // stop
          tween: Tween<double>(begin: 100, end: 100),
          weight: 2),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.repeat().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 300,
              height: 300,
              child: Center(
                child: Text(
                  'hit vao 2 lan, tho ra 1 lan\ntho ik!!!',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return Scaffold(
            body: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 500,
                    height: 500,
                    // color: Colors.red,   // uncomment to see container
                    child: Container(
                      margin: EdgeInsets.all(_marginAnimation.value),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _playAnimation();
                      },
                      child: Text('Start'))
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                createDialog(context);
              },
              child: const Text('?'),
            ),
          );
        });
  }
}
