import 'package:flutter/material.dart';

class Bubble extends StatefulWidget {
  const Bubble({Key? key}) : super(key: key);
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
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

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
            child: SizedBox(
              width: 300,
              height: 450,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '\n-Physiological sigh: hít vào một hơi thật nhanh và mạnh, ních thêm chút nữa khi bong bóng nở ra rồi thở ra từ từ khi bong bóng xẹp lại\n'
                    '\n- Phù hợp thực hành trong những tình huống bạn bị mất bình tĩnh: chuẩn bị thi, chuẩn bị đánh nhau, khủng hoảng hiện sinh...\n'
                    ' \n-Tác dụng: khiến phổi bạn nở ra và nhịp tim chậm lại, giúp bạn bình tĩnh và cân bằng cảm xúc ngay lúc thở \n\n',
                  // ' -Nguồn khoa học: https://scopeblog.stanford.edu/2020/10/07/how-stress-affects-your-brain-and-how-to-reverse-it/',
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 19,
                    ),
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
            body: Column(
              children: <Widget>[
                CircleBox(marginAnimation: _marginAnimation),
                ElevatedButton(
                    onPressed: () {
                      _playAnimation();
                    },
                    child: const Text('Bắt đầu'))
              ],
              mainAxisAlignment: MainAxisAlignment.start,
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

class CircleBox extends StatelessWidget {
  const CircleBox({
    Key? key,
    required Animation<double> marginAnimation,
  })  : _marginAnimation = marginAnimation,
        super(key: key);

  final Animation<double> _marginAnimation;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: const Alignment(0, 1),
        child: SizedBox(
          width: 350,
          height: 400,
          child: Container(
          // color: Colors.blue,   // uncomment to see container
            margin: EdgeInsets.all(_marginAnimation.value),
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              shape: BoxShape.circle,
            ),
          ),
        )
    );
  }
}
